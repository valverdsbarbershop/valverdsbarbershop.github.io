-- =========================================================================
-- VALVERD'S BARBERSHOP - SCHEMA COMPLETO DE BANCO DE DADOS (POSTGRESQL / NEON)
-- Versão Oficial de Produção: 2.5
-- Compatível com: Neon PostgreSQL, Supabase, AWS RDS, Azure Database & Local PostgreSQL
-- =========================================================================

-- Extensões úteis (opcionais / se suportado)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================================================================
-- 1. TABELA DE USUÁRIOS & CONTROLE DE ACESSO (RBAC)
-- =========================================================================
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone VARCHAR(30),
  role VARCHAR(30) NOT NULL DEFAULT 'barbeiro', -- 'superadmin', 'dono', 'barbeiro', 'recepcao', 'cliente'
  barber_key VARCHAR(50),
  cpf VARCHAR(20),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 2. TABELA DE BARBEIROS, CADEIRAS & DADOS PROFISSIONAIS
-- =========================================================================
CREATE TABLE IF NOT EXISTS barbers (
  id VARCHAR(50) PRIMARY KEY,
  barber_key VARCHAR(50) UNIQUE NOT NULL,
  name VARCHAR(150) NOT NULL,
  role VARCHAR(100),
  chair VARCHAR(50),
  avatar VARCHAR(255),
  commission_rate INTEGER DEFAULT 50,
  handle VARCHAR(50),
  rating NUMERIC(2,1) DEFAULT 5.0,
  reviews_count INTEGER DEFAULT 420,
  phone VARCHAR(30),
  email VARCHAR(150),
  start_time VARCHAR(10) DEFAULT '09:00',
  end_time VARCHAR(10) DEFAULT '19:00',
  lunch_break VARCHAR(50) DEFAULT '13:00 às 14:00',
  active_days TEXT DEFAULT 'Seg,Ter,Qua,Qui,Sex,Sáb',
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 2.1 TABELA DE ESCALAS DIÁRIAS & HORÁRIOS POR BARBEIRO (CHECKPOINTS)
-- Garante persistência atômica: se o barbeiro folgar, ficar doente ou sair
-- mais cedo em um dia específico, este registro é a fonte definitiva da verdade.
-- =========================================================================
CREATE TABLE IF NOT EXISTS barber_daily_schedules (
  id VARCHAR(64) PRIMARY KEY,                  -- Formato: '{barber_key}_{day_name}', ex: 'luis_Seg'
  barber_key VARCHAR(64) NOT NULL,             -- 'luis', 'yago', etc.
  day_name VARCHAR(16) NOT NULL,               -- 'Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'
  is_available BOOLEAN NOT NULL DEFAULT TRUE,  -- TRUE = Trabalha / FALSE = Ausente / Folga
  start_time VARCHAR(10) NOT NULL DEFAULT '09:00',
  end_time VARCHAR(10) NOT NULL DEFAULT '19:00',
  note TEXT DEFAULT '',                        -- Ex: 'Folga Semanal', 'Médico', 'Sai às 16h'
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_barber_day UNIQUE (barber_key, day_name)
);

-- =========================================================================
-- 3. TABELA DE SERVIÇOS DO SALÃO (CARDÁPIO DE CORTES & COMBOS)
-- =========================================================================
CREATE TABLE IF NOT EXISTS services (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,               -- 'Cabelo', 'Barba', 'Combo', 'Estética', 'Química'
  price NUMERIC(10,2) NOT NULL,
  duration INTEGER NOT NULL,                   -- Duração em minutos (ex: 40)
  description TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 4. TABELA DE PRODUTOS, BAR & INSUMOS (ESTOQUE, CUSTO E LUCRO DRE)
-- =========================================================================
CREATE TABLE IF NOT EXISTS products (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,               -- 'Bar', 'Cosméticos', 'Insumos'
  price NUMERIC(10,2) NOT NULL,                -- Preço de venda
  cost NUMERIC(10,2) NOT NULL DEFAULT 0.00,    -- Custo unitário para cálculo de lucro líquido
  stock INTEGER NOT NULL DEFAULT 0,
  min_stock INTEGER NOT NULL DEFAULT 5,
  type VARCHAR(50),                            -- 'Cerveja', 'Pomada', 'Óleo', 'Refrigerante', etc.
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 5. TABELA DE AGENDAMENTOS (CALENDÁRIO & CONTROLE DAS CADEIRAS)
-- =========================================================================
CREATE TABLE IF NOT EXISTS appointments (
  id BIGINT PRIMARY KEY,
  voucher_code VARCHAR(30) NOT NULL,
  client_name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  cpf VARCHAR(20) NOT NULL,
  is_cpf_verified BOOLEAN DEFAULT TRUE,
  service_name VARCHAR(255) NOT NULL,
  barber_name VARCHAR(150) NOT NULL,
  barber_key VARCHAR(50) NOT NULL,
  day_name VARCHAR(20) NOT NULL,
  appt_date VARCHAR(30) NOT NULL,              -- Formato DD/MM/AAAA ou YYYY-MM-DD
  appt_time VARCHAR(10) NOT NULL,              -- Formato HH:MM
  status VARCHAR(30) NOT NULL DEFAULT 'confirmado', -- 'confirmado', 'confirmou_presenca', 'aguardando', 'em_atendimento', 'concluido', 'cancelado', 'recusado', 'faltou'
  price NUMERIC(10,2) NOT NULL,
  total NUMERIC(10,2) NOT NULL,
  payment_method VARCHAR(50) DEFAULT 'Presencial / PIX', -- 'PIX', 'Crédito', 'Débito', 'Dinheiro'
  notes TEXT,
  items JSONB NOT NULL DEFAULT '[]'::jsonb,    -- Comanda com serviços e itens do bar
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 6. TABELA DE CONFIGURAÇÕES OPERACIONAIS (APP SETTINGS)
-- =========================================================================
CREATE TABLE IF NOT EXISTS app_settings (
  setting_key VARCHAR(100) PRIMARY KEY,
  setting_value JSONB NOT NULL DEFAULT '{}'::jsonb,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 7. TABELA DE VENDAS AVULSAS DO BALCÃO & BAR
-- =========================================================================
CREATE TABLE IF NOT EXISTS counter_sales (
  id BIGINT PRIMARY KEY,
  item_name VARCHAR(150) NOT NULL,
  category VARCHAR(80),
  quantity INTEGER NOT NULL DEFAULT 1,
  total NUMERIC(10,2) NOT NULL,
  payment_method VARCHAR(50) NOT NULL,
  sold_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  payload JSONB NOT NULL DEFAULT '{}'::jsonb
);

-- =========================================================================
-- 8. TABELA DE CLIENTES (CRM, HISTÓRICO & FIDELIDADE)
-- =========================================================================
CREATE TABLE IF NOT EXISTS clients (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  cpf VARCHAR(20) UNIQUE NOT NULL,
  phone VARCHAR(30),
  email VARCHAR(150),
  tier VARCHAR(50) DEFAULT 'Cliente VIP',
  total_spent NUMERIC(10,2) DEFAULT 0.00,
  cashback_balance NUMERIC(10,2) DEFAULT 0.00,
  loyalty_points INTEGER DEFAULT 0,
  is_blocked BOOLEAN DEFAULT FALSE,
  last_visit VARCHAR(30),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 9. TABELA DE LEADS DE MARKETING & CAPTURA
-- =========================================================================
CREATE TABLE IF NOT EXISTS marketing_leads (
  id BIGINT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  phone VARCHAR(30) NOT NULL,
  email VARCHAR(150),
  birth_date VARCHAR(30),
  source VARCHAR(150),                         -- 'Instagram', 'WhatsApp', 'QR Code', 'Google Maps'
  clicks INTEGER NOT NULL DEFAULT 1,
  registered_at VARCHAR(30),
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 10. TABELA DE LOGS DE AUDITORIA & SEGURANÇA
-- =========================================================================
CREATE TABLE IF NOT EXISTS security_logs (
  id BIGINT PRIMARY KEY,
  log_type VARCHAR(80),
  description TEXT,
  origin VARCHAR(150),
  log_date VARCHAR(50),
  status VARCHAR(50),
  payload JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 11. TABELA DE FECHAMENTOS DE CAIXA (DRE & CONTABILIDADE DIÁRIA)
-- =========================================================================
CREATE TABLE IF NOT EXISTS cash_registers (
  id SERIAL PRIMARY KEY,
  close_date VARCHAR(30) NOT NULL,
  total_services NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  total_bar_products NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  total_commissions NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  product_costs NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  net_profit NUMERIC(10,2) NOT NULL DEFAULT 0.00,
  closed_by VARCHAR(150),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- 12. TABELA DO ESCUDO ANTI-FRAUDE / ANTI NO-SHOW (CPFs BLOQUEADOS)
-- =========================================================================
CREATE TABLE IF NOT EXISTS blocked_cpfs (
  id SERIAL PRIMARY KEY,
  cpf VARCHAR(20) UNIQUE NOT NULL,
  reason TEXT DEFAULT 'No-show / Falta sem aviso prévio',
  blocked_by VARCHAR(150) DEFAULT 'Sistema / Dono',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- ÍNDICES DE ALTA PERFORMANCE (QUERY OPTIMIZATION)
-- =========================================================================
CREATE INDEX IF NOT EXISTS idx_appointments_day ON appointments (day_name);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments (appt_date);
CREATE INDEX IF NOT EXISTS idx_appointments_barber ON appointments (barber_key);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments (status);
CREATE INDEX IF NOT EXISTS idx_appointments_cpf ON appointments (cpf);
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_clients_cpf ON clients (cpf);
CREATE INDEX IF NOT EXISTS idx_blocked_cpfs ON blocked_cpfs (cpf);
CREATE INDEX IF NOT EXISTS idx_counter_sales_sold_at ON counter_sales (sold_at);
CREATE INDEX IF NOT EXISTS idx_marketing_leads_phone ON marketing_leads (phone);
CREATE INDEX IF NOT EXISTS idx_barber_daily_schedules_key ON barber_daily_schedules (barber_key);
CREATE INDEX IF NOT EXISTS idx_barber_daily_schedules_day ON barber_daily_schedules (day_name);

-- =========================================================================
-- CARGA DE DADOS INICIAIS (SEEDS DE PRODUÇÃO)
-- =========================================================================

-- A. Usuários Oficiais
INSERT INTO users (name, email, password_hash, phone, role, barber_key, cpf)
VALUES 
  ('Bernardo Lamin', 'bernardolamin3@gmail.com', 'admin123', '(21) 99999-0001', 'superadmin', 'luis', '000.000.000-00'),
  ('Luis Valverde', 'valverdsbarbeshop@gmail.com', 'valverds2026', '(21) 97010-0668', 'dono', 'luis', '000.000.000-00'),
  ('Yago Barber', 'yago@valverds.com', 'yago123', '(21) 98888-2222', 'barbeiro', 'yago', '000.000.000-00'),
  ('Recepção Valverd''s', 'recepcao@valverds.com', 'recepcao123', '(21) 97010-0668', 'recepcao', 'recepcao', '000.000.000-00')
ON CONFLICT (email) DO UPDATE SET 
  name = EXCLUDED.name,
  role = EXCLUDED.role,
  password_hash = EXCLUDED.password_hash,
  phone = EXCLUDED.phone;

-- B. Barbeiros Oficiais
INSERT INTO barbers (id, barber_key, name, role, chair, avatar, commission_rate, handle, rating, reviews_count, phone, email, start_time, end_time, lunch_break, active_days)
VALUES 
  ('luis', 'luis', 'Luis Valverde', 'Proprietário & Mestre Barbeiro', 'Cadeira 01', 'luis_valverde.jpg', 60, '@luisvalverde', 5.0, 420, '(21) 97010-0668', 'valverdsbarbeshop@gmail.com', '09:00', '19:00', '12:30 às 13:30', 'Seg,Ter,Qua,Qui,Sex,Sáb'),
  ('yago', 'yago', 'Yago Barber', 'Barbeiro Especialista', 'Cadeira 02', 'foto_barbeiro_yago.jpg', 50, '@yagobarber', 5.0, 420, '(21) 98888-2222', 'yago@valverds.com', '10:00', '19:00', '13:00 às 14:00', 'Ter,Qua,Qui,Sex,Sáb')
ON CONFLICT (barber_key) DO UPDATE SET 
  name = EXCLUDED.name,
  role = EXCLUDED.role,
  chair = EXCLUDED.chair,
  avatar = EXCLUDED.avatar,
  commission_rate = EXCLUDED.commission_rate,
  rating = EXCLUDED.rating,
  reviews_count = EXCLUDED.reviews_count,
  start_time = EXCLUDED.start_time,
  end_time = EXCLUDED.end_time;

-- C. Escalas Diárias Relacionais (Checkpoints Dia a Dia)
INSERT INTO barber_daily_schedules (id, barber_key, day_name, is_available, start_time, end_time, note)
VALUES
  ('luis_Dom', 'luis', 'Dom', FALSE, '09:00', '19:00', 'Fechado'),
  ('luis_Seg', 'luis', 'Seg', TRUE,  '09:00', '19:00', ''),
  ('luis_Ter', 'luis', 'Ter', TRUE,  '09:00', '19:00', ''),
  ('luis_Qua', 'luis', 'Qua', TRUE,  '09:00', '19:00', ''),
  ('luis_Qui', 'luis', 'Qui', TRUE,  '09:00', '19:00', ''),
  ('luis_Sex', 'luis', 'Sex', TRUE,  '09:00', '19:00', ''),
  ('luis_Sáb', 'luis', 'Sáb', TRUE,  '09:00', '19:00', ''),
  ('yago_Dom', 'yago', 'Dom', FALSE, '10:00', '19:00', 'Fechado'),
  ('yago_Seg', 'yago', 'Seg', FALSE, '10:00', '19:00', 'Folga Semanal'),
  ('yago_Ter', 'yago', 'Ter', TRUE,  '10:00', '19:00', ''),
  ('yago_Qua', 'yago', 'Qua', TRUE,  '10:00', '19:00', ''),
  ('yago_Qui', 'yago', 'Qui', TRUE,  '10:00', '19:00', ''),
  ('yago_Sex', 'yago', 'Sex', TRUE,  '10:00', '19:00', ''),
  ('yago_Sáb', 'yago', 'Sáb', TRUE,  '10:00', '19:00', '')
ON CONFLICT (barber_key, day_name) DO UPDATE SET
  is_available = EXCLUDED.is_available,
  start_time = EXCLUDED.start_time,
  end_time = EXCLUDED.end_time,
  note = EXCLUDED.note;

-- D. Serviços Oficiais da Barbearia
INSERT INTO services (id, name, category, price, duration, description)
VALUES 
  ('s1', 'Corte Cabelo Social / Clássico', 'Cabelo', 40.00, 40, 'Tesoura ou máquina com acabamento refinado a navalha.'),
  ('s2', 'Corte Degradê / Fade Moderno', 'Cabelo', 45.00, 45, 'Taper fade, mid fade, high fade ou navalhado impecável.'),
  ('s3', 'Barba Terapia com Toalha Quente', 'Barba', 35.00, 35, 'Modelagem com navalha, toalha quente e óleos essenciais.'),
  ('s4', 'Combo Completo Cabelo + Barba', 'Combo', 70.00, 60, 'Corte completo com barba terapia e café cortesia.'),
  ('s5', 'Pezinho & Acabamento Navalhado', 'Cabelo', 20.00, 20, 'Alinhamento dos contornos com navalha e loção refrescante.'),
  ('s6', 'Sobrancelha na Navalha / Pinça', 'Estética', 15.00, 15, 'Design e limpeza masculina natural.'),
  ('s7', 'Platinado / Nevou Global', 'Química', 140.00, 120, 'Descoloração global com matização e tratamento reconstrutor.')
ON CONFLICT (id) DO UPDATE SET 
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  duration = EXCLUDED.duration,
  description = EXCLUDED.description;

-- E. Produtos do Bar & Cosméticos
INSERT INTO products (id, name, category, price, cost, stock, min_stock, type)
VALUES 
  ('p1', 'Cerveja Stella Artois (330ml)', 'Bar', 12.00, 5.50, 24, 6, 'Cerveja'),
  ('p2', 'Cerveja Heineken Long Neck (330ml)', 'Bar', 14.00, 6.20, 24, 6, 'Cerveja'),
  ('p3', 'Pomada Modeladora Matte Efeito Seco', 'Cosméticos', 45.00, 18.00, 12, 3, 'Pomada'),
  ('p4', 'Óleo Hidratante para Barba (30ml)', 'Cosméticos', 38.00, 15.00, 10, 2, 'Óleo'),
  ('p5', 'Refrigerante Coca-Cola Lata', 'Bar', 6.00, 2.80, 30, 6, 'Bebida'),
  ('p6', 'Café Expresso Nespresso Gourmet', 'Bar', 0.00, 1.50, 50, 10, 'Cortesia')
ON CONFLICT (id) DO UPDATE SET 
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  cost = EXCLUDED.cost,
  stock = EXCLUDED.stock,
  min_stock = EXCLUDED.min_stock;
