-- =========================================================================
-- VALVERD'S BARBERSHOP — SCHEMA OFICIAL DE PRODUÇÃO (NEON POSTGRESQL)
-- Versão 2.4 — Produção AWS São Paulo (sa-east-1)
-- =========================================================================

-- 1. TABELA DE USUÁRIOS & PERMISSÕES (RBAC)
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

-- 2. TABELA DE BARBEIROS / CADEIRAS & ESCALAS
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

-- 3. TABELA DE SERVIÇOS OFICIAIS
CREATE TABLE IF NOT EXISTS services (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  duration INTEGER NOT NULL,
  description TEXT,
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. TABELA DE PRODUTOS, BAR & INSUMOS (ESTOQUE & DRE)
CREATE TABLE IF NOT EXISTS products (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  category VARCHAR(50) NOT NULL,
  price NUMERIC(10,2) NOT NULL,
  cost NUMERIC(10,2) NOT NULL DEFAULT 0.00, -- Custo real unitário para cálculo de lucro líquido
  stock INTEGER NOT NULL DEFAULT 0,
  min_stock INTEGER NOT NULL DEFAULT 5,
  type VARCHAR(50),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. TABELA DE AGENDAMENTOS (SINCRONIZAÇÃO EM TEMPO REAL)
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
  appt_date VARCHAR(30) NOT NULL,
  appt_time VARCHAR(10) NOT NULL,
  status VARCHAR(30) NOT NULL DEFAULT 'confirmado', -- 'confirmado', 'aguardando', 'em_atendimento', 'concluido', 'cancelado'
  price NUMERIC(10,2) NOT NULL,
  total NUMERIC(10,2) NOT NULL,
  payment_method VARCHAR(50) DEFAULT 'Presencial / PIX',
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. TABELA DE CLIENTES (CRM, HISTÓRICO & FIDELIDADE)
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

-- 7. TABELA DE FECHAMENTOS DE CAIXA (DRE & HISTÓRICO FINANCEIRO)
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

-- 8. TABELA DO ESCUDO ANTI-FRAUDE / ANTI NO-SHOW (LISTA DE RESTRIÇÃO)
CREATE TABLE IF NOT EXISTS blocked_cpfs (
  id SERIAL PRIMARY KEY,
  cpf VARCHAR(20) UNIQUE NOT NULL,
  reason TEXT DEFAULT 'No-show / Falta sem aviso prévio',
  blocked_by VARCHAR(150) DEFAULT 'Sistema / Dono',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================================
-- ÍNDICES PARA ALTA PERFORMANCE & CONSULTAS RÁPIDAS
-- =========================================================================
CREATE INDEX IF NOT EXISTS idx_appointments_day ON appointments (day_name);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments (appt_date);
CREATE INDEX IF NOT EXISTS idx_appointments_barber ON appointments (barber_key);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments (status);
CREATE INDEX IF NOT EXISTS idx_appointments_cpf ON appointments (cpf);
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_clients_cpf ON clients (cpf);
CREATE INDEX IF NOT EXISTS idx_blocked_cpfs ON blocked_cpfs (cpf);

-- =========================================================================
-- CARGA DE DADOS OFICIAIS (SEEDS DE PRODUÇÃO)
-- =========================================================================

-- Inserir Usuários Oficiais do Sistema (Admin Master, Dono, Barbeiro e Recepção)
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

-- Inserir Barbeiros Oficiais (Nota 5.0 com 420 Avaliações)
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

-- Inserir Cardápio Oficial de Serviços
INSERT INTO services (id, name, category, price, duration, description)
VALUES 
  ('s1', 'Corte Cabelo Social / Clássico', 'Cabelo', 40.00, 40, 'Tesoura ou máquina com acabamento refinado a navalha.'),
  ('s2', 'Corte Degradê / Fade Moderno', 'Cabelo', 45.00, 45, 'Taper fade, mid fade, high fade ou navalhado impecável.'),
  ('s3', 'Barba Terapia com Toalha Quente', 'Barba', 35.00, 35, 'Modelagem com navalha, toalha quente e óleos essenciais.'),
  ('s4', 'Combo Completo Cabelo + Barba', 'Combo', 70.00, 60, 'Corte completo com barba terapia e café cortesia.'),
  ('s5', 'Pezinho & Acabamento Navalhado', 'Cabelo', 20.00, 20, 'Alinhamento dos contornos com navalha e loção refrescante.'),
  ('s6', 'Sobrancelha na Navalha / Pinça', 'Estética', 15.00, 15, 'Design e limpeza masculina natural.')
ON CONFLICT (id) DO UPDATE SET 
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  price = EXCLUDED.price,
  duration = EXCLUDED.duration,
  description = EXCLUDED.description;

-- Inserir Estoque Real do Bar, Bebidas & Cosméticos (com Custos Unitários para DRE)
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
