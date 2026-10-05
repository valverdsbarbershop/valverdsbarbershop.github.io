# Valverd's BarberShop — Sistema Web de Gestão (MVP)

> *"Beard, hair and mustache"* — Fundada em 2022

Sistema completo de gestão para barbearia premium, mobile-first, com identidade visual clássica/vintage (fundo preto `#0B0B0B`, superfícies `#161512` com bordas sutis de 0.5px, dourado nobre `#C9A356` e tipografia *Cinzel* / *Plus Jakarta Sans*).

---

## 🚀 1. Como Abrir e Testar Agora Mesmo

A aplicação foi desenvolvida como uma Single-Page Application (SPA) moderna e independente. **Não é necessário instalar Node.js, Python ou qualquer dependência local para testar:**

1. Vá até a pasta do projeto:
   ```text
   C:\Users\blaminma\.gemini\antigravity\scratch\valverds-barbershop\
   ```
2. Dê um **duplo clique no arquivo `index.html`** (ou abra-o em qualquer navegador: Google Chrome, Microsoft Edge, Safari, Firefox).
3. O sistema será carregado instantaneamente com a logo original e dados realistas pré-configurados!

---

## 👑 2. Simulação de Perfis de Usuário (Role Switcher)

Na barra superior escura fixa, você pode alternar em **1 clique** entre as 5 visões do sistema:

1. **👑 Dono / Admin**:
   - **Dashboard Executivo**: Faturamento do dia, total de comissões, despesas, lucro líquido real, ticket médio.
   - **Gráficos e Ranking**: Distribuição por forma de pagamento (Pix, Cartão de Crédito, Débito, Dinheiro) e produtividade por barbeiro.
   - **Estoque**: Visão de itens de revenda (pomadas, óleos) e de uso interno (lâminas, espuma), com alertas destacados de estoque baixo/crítico.
   - **WhatsApp Meta API**: Tela de configuração de templates e disparo de mensagens.
2. **💼 Gerente**:
   - Agenda completa das cadeiras, equipe de barbeiros, clientes e histórico operacional.
3. **💈 Barbeiro (App Mobile-First)**:
   - Interface de bolso pensada para o celular do profissional.
   - Destaque para o **"Próximo Atendimento"** com botão rápido para iniciar corte e concluir.
   - Cards de atendimentos do dia, avaliação (estrelas) e extrato de comissão acumulada.
   - Menu inferior: Agenda, Comissões, Clientes, Perfil.
4. **🛎️ Recepção**:
   - Controle das cadeiras, encaixe rápido de clientes e **Caixa do Turno** (abertura, entradas e fechamento diário com conferência de gaveta).
5. **📱 Portal do Cliente (Mobile-First)**:
   - Experiência autônoma para o cliente:
     1. Seleção do serviço com preço e tempo estimado.
     2. Escolha do barbeiro preferido com foto e avaliações.
     3. Seleção do horário disponível no dia.
     4. Confirmação do agendamento com botão dourado de destaque.
   - **Cartão Fidelidade Visual**: Mostra quantos cortes já foram feitos e quantos faltam para o corte gratuito (ex: 8 de 10).

---

## 🗄️ 3. Estrutura do Banco de Dados Relacional

Na pasta `database/`, foram disponibilizados os scripts de nível de produção:

- **`database/schema.sql`**: Esquema DDL completo para PostgreSQL / MySQL:
  - Tabela `users` com enum RBAC (`admin`, `manager`, `barber`, `receptionist`, `client`).
  - Tabela `barbers` com comissões configuráveis, especialidades e horários de trabalho.
  - Tabela `clients` com preferências de corte, histórico e pontos de fidelidade.
  - Tabela `services` com valores, durações e categorias.
  - Tabela `appointments` com status (`scheduled`, `confirmed`, `in_progress`, `completed`, `cancelled`) e índices anti-sobreposição.
  - Tabela `financial_transactions` com rateio automático de comissão e métodos de pagamento (`pix`, `credit_card`, `debit_card`, `cash`).
  - Tabela `cash_registers` com conferência diária de gaveta e sangrias.
  - Tabela `products` e `stock_movements` para controle de insumos e produtos de revenda.
  - Tabela `whatsapp_settings` e templates aprovados pela Meta.
- **`database/seed.sql`**: Carga inicial com serviços clássicos da Valverd's, barbeiros, clientes e estoque.

---

## 📱 4. Integração com WhatsApp (Meta Cloud API / BSP)

O sistema conta com um módulo modular para notificações via WhatsApp:
- Disparo dinâmico formatado com links `https://wa.me/55...` prontos para teste direto no navegador ou WhatsApp Web/Mobile.
- Modelo de variáveis para template aprovado da Meta:
  ```text
  Olá {{cliente}}, seu agendamento na Valverd's BarberShop está confirmado para {{data}} às {{horario}} com {{barbeiro}} ({{servico}}). Te esperamos! 💈✂️
  ```

---

## 🛠️ 5. Próximos Passos (Fase 2)

Quando desejar avançar além do MVP:
1. Conectar a um backend dedicado em Node.js (NestJS / Express) ou Python (FastAPI).
2. Provisionar banco PostgreSQL no Supabase, Neon ou Railway.
3. Habilitar webhooks de confirmação bidirecional do WhatsApp (o cliente responde "1" para confirmar ou "2" para reagendar).
