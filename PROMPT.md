# Prompt Completo de Engenharia — Plataforma Web Valverd's BarberShop

> **Como usar:** Copie e cole todo o conteúdo deste arquivo na ferramenta de IA que você for usar para gerar ou estender o código (Cursor, Claude Code, Lovable, v0, Bolt, etc.). O documento já incorpora os dados e imagens oficiais do **Valverd's BarberShop** em Resende/RJ, além dos padrões visuais de barbearias de alto padrão (ex: Ganza Co.) e benchmarks de mercado de 2026 (*Trinks*, *Booksy*, *Belio*).

---

## PROMPT

Você é um desenvolvedor full-stack sênior especialista em UI/UX e sistemas para barbearias de alto padrão. Quero que você crie uma **plataforma web completa para o Valverd's BarberShop**, moderna, responsiva, com visual vintage editorial de luxo e fluxo integrado de agendamentos e gestão interna.

### 1. Visão Geral do Negócio & Marca Oficial
- **Nome da barbearia:** Valverd's BarberShop (Valverd's Co. — Barbearia)
- **Slogan:** "Beard, hair and mustache"
- **Tagline:** "Dê um tapa no seu estilo!"
- **Ano de fundação:** 2022
- **Localização Oficial:** Campos Elíseos — Resende / RJ
- **Horário de Atendimento:** Segunda a Sábado: 09h00 às 19h00
- **Contato & Redes:**
  - WhatsApp: `(21) 97010-0668` (`wa.me/5521970100668`)
  - Instagram: `@valverds.barber`
- **Equipe de Barbeiros Oficiais:**
  - **Luis Valverde** (`@luisvalverdelv`) — Fundador & Mestre Barbeiro (especialista em cortes clássicos, fade e barboterapia).
  - **Yago Barber** (`@yago_barber9`) — Especialista em fade, degradê navalhado, barba e tendências contemporâneas.
- **Pilares Oficiais da Marca:**
  1. 👑 *Atendimento de Respeito:* Pontualidade, acolhimento e escuta atenta aos desejos do cliente.
  2. ✂️ *Corte Alinhado e Preciso:* Técnica apurada na tesoura e máquina para valorizar cada formato de rosto.
  3. ⭐ *Resultado que Eleva sua Imagem:* Confiante para compromissos profissionais e sociais.
  4. 🤝 *Relacionamento que Gera Lealdade:* Mais que clientes, amigos e comunidade fiel.

---

### 2. Tabela Oficial de Serviços e Preços
A tabela de serviços deve refletir exatamente os preços praticados pela barbearia:
1. **Corte Masculino:** R$ 40,00 (40 min) — Técnica precisa na tesoura ou máquina, corte alinhado e finalização impecável.
2. **Corte Infantil:** R$ 50,00 (35 min) — Atendimento com calma, respeito e paciência para as crianças saírem no estilo.
3. **Barba + Cabelo (Combo Especial):** R$ 65,00 (60 min) — A experiência completa: corte alinhado e barba desenhada na navalha quente.
4. **Somente Barba:** R$ 35,00 (30 min) — Barboterapia com toalha quente, navalha afiada, óleos essenciais e pós-barba.
5. **Design de Sobrancelha:** R$ 20,00 (15 min) — Alinhamento preciso na navalha para realçar o olhar.
6. **Hidratação Capilar Profunda:** R$ 30,00 (25 min) — Tratamento revitalizante para dar brilho e maciez aos fios.

---

### 3. Design System & Arquitetura Visual (Fiel à Referência Visual)

#### 3.1 Cores e Tipografia
- **Sidebar & Fundo Escuro:** `#0B0B0B` (Preto profundo), `#161512` (Cards texturizados), `#2A261F` (Bordas sutis).
- **Área de Conteúdo:** `#FFFFFF` (Branco puro) e `#FAFAF8` (Cinza nobre quente para contraste com a sidebar).
- **Dourado de Destaque:** `#C9A356` (Ouro nobre / Vintage Gold), `#B59044` (Hover).
- **Tipografia:**
  - Títulos e Logomarca: Fonte serifada clássica (`Cinzel`, `Playfair Display` ou `Trajan`), caixa alta com tracking largo (`letter-spacing: 0.25em`).
  - Textos de Apoio e Sistema: Sans-serif legível e moderno (`Inter`).

#### 3.2 Sidebar Fixa Lateral Esquerda (Desktop ~145px)
- **Largura fixa:** ~145px, fixada à esquerda da tela em `#0B0B0B`.
- **Topo:** Logo Valverd's oficial (`Valverde.jpg`) com bigode, navalha em V e tesoura, e o texto `EST. 2022`.
- **Itens de Navegação Verticais:** Ícones vetoriais lineares dourados (`#C9A356`) centralizados acima de rótulos em caixa alta (`Cinzel`, `tracking-widest`, 10px-11px, `#E0DDD5`):
  1. `HOME` (ícone de gravata borboleta vintage)
  2. `SOBRE NÓS` (ícone de bigode e barba)
  3. `ESPAÇO` (ícone de navalhas cruzadas)
  4. `SERVIÇOS` (ícone de tesoura clássica)
  5. `BEBIDAS` (ícone de pente e navalha)
  6. `EQUIPE` (ícone de tesoura de corte)
  7. `RESENDE` (ícone de pin de mapa)
- **Base da Sidebar:** Botão alternador para **"PAINEL GESTÃO"** (acesso à área restrita do dono e equipe).
- **Mobile:** Menu horizontal responsivo com drawer retrátil.

#### 3.3 Botão Flutuante de Agendamento
- Fixado no canto inferior direito (`bottom-6 right-6`), estilo grafite escuro (`#0B0B0B`), texto e borda dourados (`#C9A356`): **"✂️ Agende pelo app"**.

---

### 4. Seções da Página Pública

1. **Hero Section:**
   - Fotografia oficial do fundador Luis Valverde com camisa polo e logo ao fundo (`barbeiro_valverds.jpg`).
   - Emblema central vintage:
     - `CAMPOS ELÍSEOS • RESENDE / RJ`
     - `VALVERD'S BarberShop — Desde 2022`
     - `"Beard, hair and mustache"`
     - `"Dê um tapa no seu estilo!"`
   - Botões de ação: "Agende Seu Horário (A Partir de R$ 40)" e "💬 WhatsApp: (21) 97010-0668".

2. **Pilares Oficiais da Marca:**
   - Cards com ícones dos 4 pilares: Atendimento de Respeito, Corte Alinhado e Preciso, Resultado que Eleva sua Imagem e Relacionamento que Gera Lealdade.

3. **Seção "Sobre Nós":**
   - **Esquerda:** Foto real de Luis Valverde no atendimento.
   - **Direita:** Ícone dourado de navalha/barba, título `S O B R E - N Ó S`, história da barbearia desde 2022 em Resende / RJ.
   - Indicadores: Fundação 2022, Resende / RJ e Avaliação 5.0 ★★★★★.

4. **Seção "Espaço" (Carrossel):**
   - Carrossel de imagens com fotos reais do barbeiro, atendimento ao cliente no espelho (`corte_cliente.png`), tabela oficial (`tabela_precos.png`) e ambiente vintage, com botões anterior/próximo e contador minimalista.

5. **Seção "Serviços e Valores":**
   - Destaque 1: Corte Masculino (R$ 40,00) com foto real de atendimento.
   - Destaque 2: Barba + Cabelo Combo Especial (R$ 65,00) com selo "Mais Pedido".
   - Tabela Completa: Cardápio com os 6 serviços oficiais e botão de agendamento imediato.

6. **Seção "Bebidas & Bar":**
   - Bebidas comercializadas: Heineken, IPA Artesanal, Corona Extra, Café Espresso Gourmet (cortesia) e Água Mineral.

7. **Seção "Nossa Equipe":**
   - Perfil de Luis Valverde (`@luisvalverdelv`, Mestre Barbeiro & Fundador) e Yago Barber (`@yago_barber9`, Fade & Estilo) com especialidades e botão de agendamento por profissional.

8. **Seção "Localização — Resende / RJ":**
   - Endereço em Campos Elíseos, horários (09h às 19h), link direto do WhatsApp `(21) 97010-0668` e foto da tabela oficial de preços do Instagram.

---

### 5. Área de Login & Painel de Gestão (Admin)

#### 5.1 Tela de Login
- Login com e-mail e senha.
- Botões de acesso rápido com 1 clique para demonstração:
  - 👑 **Luis Valverde** (Dono / Mestre Barbeiro)
  - ✂️ **Yago Barber** (Barbeiro Parceiro)
  - 📋 **Recepção** (Gerente de Atendimento)

#### 5.2 Painel de Gestão Operacional
- **Aba 1: Agenda & Cadeiras:**
  - Fluxo de atendimentos do dia com horários, clientes, serviços e barbeiros.
  - Status em tempo real: *Agendado*, *Na Cadeira*, *Concluído*.
  - Modal de Fechamento de Comanda com acréscimo de bebidas consumidas e método de pagamento (PIX, Débito, Crédito, Dinheiro).
- **Aba 2: Financeiro & DRE:**
  - Receita bruta calculada automaticamente, rateio de comissões (Luis 60%, Yago 50%) e lucro líquido operacional.
- **Aba 3: Estoque do Bar:**
  - Controle de cervejas, refrigerantes e café com botões de adição e baixa instantânea de estoque.
- **Aba 4: Equipe & Comissões:**
  - Quadro de barbeiros com métricas individuais, taxas de comissão e notas de avaliação.

---

### 6. Modal de Agendamento Inteligente
Fluxo em 3 etapas simples para o cliente:
1. Escolher o serviço oficial (com duração e preço claro).
2. Escolher o barbeiro (Luis Valverde ou Yago Barber).
3. Informar nome, WhatsApp e selecionar horário disponível (09:00 às 18:00).
- Confirmação com resumo e link direto para avisar a barbearia no WhatsApp.
