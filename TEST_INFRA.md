# TEST_INFRA.md — E2E Testing Infrastructure Specification
**Project:** Valverd's BarberShop — "Beard, hair and mustache"  
**Scope:** Complete End-to-End Testing Architecture & Verification Harness across Tiers 1–4  
**Authoritative Specifications:** `ORIGINAL_REQUEST.md` & `PROJECT.md`  
**Execution Runtime:** PowerShell 7.6+ & Microsoft Edge Headless (Chromium V8)  
**Version:** 1.0.0 — Official  

---

## 1. Test Philosophy & Core Principles

The End-to-End (E2E) testing framework for Valverd's BarberShop is engineered to provide an uncompromised, automated quality gate ensuring that every requirement (R1 through R4) achieves executive luxury polish, deterministic mathematical precision, responsive layout stability, and rock-solid database integration.

### 1.1 Opaque-Box & Behavior-Driven Testing
All tests exercise the system from the outside in. We evaluate observable DOM outputs, rendered typography and color tokens, persisted `localStorage` states, network/SQL connectivity, and business calculation outputs. Tests avoid coupling to transient internal React component names, ensuring tests survive refactoring as long as behavioral contracts are preserved.

### 1.2 Authoritative Expected Output Derivation
Every test asserts against an authoritative expected value derived directly from:
1. **Requirements Specifications**: `ORIGINAL_REQUEST.md` (e.g., 48 blocks from 00:00 to 23:30, dark palette `#0B0B0B`, clean palette `#F8F9FA`, Luis commission 60%, Yago commission 50%).
2. **Interface Contracts**: `PROJECT.md` § Interface Contracts (Theme System, Schedule System, Financial & DRE).
3. **Mathematical Reference Oracles**: Independent, closed-form formulas implemented in the test harness (e.g. `tests/helpers/dre_reference_oracle.ps1`), ensuring zero regression in accounting calculations.

### 1.3 Test Independence & Isolation
Every test case is fully isolated. Tests do not rely on side-effects or execution ordering from prior tests. When browser storage or state transitions are validated, sandboxed contexts or isolated data sessions are instantiated and cleanly disposed.

### 1.4 Progressive Testability
The test runner is designed to support phased verification throughout project milestones:
- Can execute the complete test suite across all Tiers (`-Tier All`).
- Can target individual tiers (`-Tier 1`, `-Tier 2`, `-Tier 3`, `-Tier 4`).
- Can filter tests by implementation milestone (`-Milestone M1`, `-Milestone M2`, `-Milestone M3`, `-Milestone M4`).
- Produces unambiguous diagnostic feedback pinpointing exact assertions, observed vs expected values, and failure context.

### 1.5 Deterministic Exit Codes
The test runner strictly adheres to CI/CD exit code conventions:
- **Exit Code 0**: 100% of executed tests passed.
- **Exit Code 1**: One or more tests failed.
Zero false positives, zero facade assertions.

---

## 2. Test Architecture & Technology Stack

The testing infrastructure runs natively in Windows environments using modern built-in tooling without requiring external npm test packages:

```
+-------------------------------------------------------------------------------+
|                             PowerShell 7 Runner                               |
|                         (tests/run_e2e_tests.ps1)                             |
+-------------------------------------------------------------------------------+
       |                         |                          |
       v                         v                          v
+---------------+        +---------------+          +---------------+
| Headless DOM  |        | Headless V8   |          | Contract & DB |
|  Inspection   |        |  Evaluation   |          |  Verification |
| (Edge Engine) |        | (Edge Engine) |          | (AST / Regex) |
+---------------+        +---------------+          +---------------+
       |                         |                          |
       +-------------------------+--------------------------+
                                 |
                                 v
        +-------------------------------------------------+
        |           Multi-Tier Test Harnesses             |
        |  Tier 1: Feature Coverage (R1-R4)               |
        |  Tier 2: Boundary & Corner Cases                |
        |  Tier 3: Cross-Feature Interactions             |
        |  Tier 4: Real-World Workload Scenarios          |
        +-------------------------------------------------+
                                 |
                                 v
        +-------------------------------------------------+
        | Report Generator & Summary (TEST_READY.md)      |
        +-------------------------------------------------+
```

### 2.1 Execution Engines
1. **Microsoft Edge Headless (Chromium Engine)**:
   - Executable: `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe` (or `C:\Program Files\...`).
   - Flags: `--headless --disable-gpu --dump-dom --log-level=3`.
   - Capabilities: Renders the full React 18 SPA via Babel standalone, evaluates live DOM nodes, extracts computed styles, checks viewport constraints, and executes in-browser state machines.
2. **Headless JavaScript V8 Engine via Edge Data URIs**:
   - Enables fast, headless execution of complex state machines, DRE calculations, and scheduling algorithms in a 100% standards-compliant ECMAScript environment.
3. **PowerShell 7 Native Contract Engine**:
   - Performs rapid static analysis, token validation, file asset verification, `.env` parsing, and Neon PostgreSQL network socket/TLS handshakes.

---

## 3. Feature Inventory & Acceptance Mapping

| Req | Feature Name | Description | Target File(s) | Test Tier(s) |
| :--- | :--- | :--- | :--- | :--- |
| **R1** | Luxury Aesthetics & Typography | Cinzel, Plus Jakarta Sans, gold accents (`#C9A356`), responsive container (`max-w-[1440px]`), no horizontal overflow | `index.html` | Tier 1, Tier 2 |
| **R1** | Photo Assets & Carousel | 18 verified local photo assets, autoplay, slide counter (`01/09`), vector navigation arrows | `index.html`, root images | Tier 1 |
| **R1** | Navigation Bug Fix | Line 967 bug fix (`setClientTab('agendamentos')` -> `'agendar'`) | `index.html` | Tier 1 |
| **R2** | Dark/Clean Theme Core | `valverds_theme` state, `localStorage` persistence, `html.clean-mode` CSS palette (`#F8F9FA`, `#FFFFFF`, `#111827`) | `index.html` | Tier 1, Tier 3 |
| **R2** | Header Theme Toggle | 1-click Sun/Moon toggle across all 5 views (Site, Cliente, Barbeiro, Recepção, Dono) | `index.html` | Tier 1, Tier 3 |
| **R3** | 48-Slot Schedule Grid | 48 blocks of 30 min from `00:00` to `23:30` (`ALL_48_TIME_SLOTS`) | `index.html` | Tier 1, Tier 2, Tier 4 |
| **R3** | Dynamic Custom Slots | Addition of custom times (`08:15`, `19:40`), dynamic sorting & deduplication in booking and chair comparison | `index.html` | Tier 1, Tier 2, Tier 4 |
| **R3** | 5-Step Guided Booking | Step 1 (Barber) -> Step 2 (Service + Bar) -> Step 3 (Day) -> Step 4 (Time) -> Step 5 (Client Info + WhatsApp + Toast) | `index.html` | Tier 1, Tier 3, Tier 4 |
| **R3** | Client Privacy Protection | Client calendar hides customer names; shows slot vacancy counts only | `index.html` | Tier 1, Tier 3 |
| **R4** | Mathematical DRE | Service vs Bar split, Luis 60%, Yago 50%, 0% commission on bar items, supply cost CMV deduction, Net Profit & Margin % | `index.html` | Tier 1, Tier 2, Tier 3, Tier 4 |
| **R4** | Multi-Day DRE & Counter Sales | DRE dynamically reflects active day/period; counter sales persist in `localStorage` | `index.html` | Tier 1, Tier 3, Tier 4 |
| **R4** | Barber & Reception Management | `wa.me` WhatsApp links, booked vs free counters, daily shift entry/exit/off settings, inventory stock `+`/`-`, product cost field | `index.html` | Tier 1, Tier 4 |
| **R4** | Neon PostgreSQL Database | `.env` credentials, `schema.sql` (PostgreSQL 18.6 DDL), `seed.sql` (initial data), network & API connectivity | `database/*`, `.env` | Tier 1, Tier 2 |

---

## 4. Test Tier Structure & Test Specifications

### 4.1 Tier 1: Feature Coverage (Acceptance Criteria)
Validates primary happy paths and baseline contracts for each requirement:
- **T1.1 (R1 Typography & Styling)**:
  - Asserts Cinzel and Plus Jakarta Sans are linked from Google Fonts and defined in `tailwind.config`.
  - Asserts `#root` and `html, body` enforce `overflow-x: hidden`.
  - Asserts `.app-container` defines `max-width: 1440px`.
  - Asserts gold metallic color `#C9A356` is configured as primary accent.
- **T1.2 (R1 Local Photo Assets)**:
  - Asserts all 18 photographic assets referenced in code exist on disk with valid file sizes (>10KB).
- **T1.3 (R1 Carousel & Navigation)**:
  - Asserts carousel elements (slide counter, vector arrows) and ensures line 967 white screen bug (`setClientTab('agendamentos')`) is eliminated.
- **T1.4 (R2 Theme Toggle & Storage)**:
  - Asserts `localStorage.getItem('valverds_theme')` contract (`'dark'` / `'clean'`).
  - Asserts `html.clean-mode` CSS class rules exist for light background `#F8F9FA`, card surface `#FFFFFF`, and dark text `#111827`.
  - Asserts header contains Sun/Moon toggle icons across all application views.
- **T1.5 (R3 48 Universal Schedule Slots)**:
  - Asserts presence of 48-slot array (`ALL_48_TIME_SLOTS`) containing exactly 48 items from `'00:00'` to `'23:30'` in 30-minute steps.
- **T1.6 (R3 Dynamic Custom Slots)**:
  - Asserts dynamic merging logic correctly integrates custom slots (e.g. `'08:15'`, `'19:40'`) in chronological order without duplicates.
- **T1.7 (R3 5-Step Booking Flow)**:
  - Asserts presence and structure of the 5-step guided stepper (Barber -> Service+Bar -> Day -> Time -> Client Info + Toast).
- **T1.8 (R3 Client Privacy Protection)**:
  - Asserts client calendar views do not expose client identities, names, or phone numbers to unauthorized views.
- **T1.9 (R4 DRE Formulas & Commission Split)**:
  - Asserts DRE separation: Gross Revenue = Services + Bar + Counter Sales.
  - Asserts Luis commission rate = 60%, Yago commission rate = 50%.
  - Asserts bar revenue generates 0% barber commission.
  - Asserts Net Profit = Gross Revenue - Commissions - Supplies Cost - Fixed Costs.
  - Asserts Net Margin % = (Net Profit / Gross Revenue) * 100.
- **T1.10 (R4 Neon PostgreSQL Integration)**:
  - Asserts `.env` file contains valid Neon connection strings (`DATABASE_URL`, `DATABASE_URL_POOLED`, `NEON_AUTH_BASE_URL`).
  - Asserts `database/schema.sql` defines required tables (`barbers`, `services`, `products`, `clients`, `appointments`, `appointment_items`, `financial_records`, `daily_settings`).
  - Asserts `database/seed.sql` configures Luis Valverde (60%) and Yago Barber (50%).

---

### 4.2 Tier 2: Boundary & Corner Cases
Validates extreme values, edge slot transitions, format anomalies, and empty collections:
- **T2.1 (Earliest & Latest Slots)**:
  - Tests boundary slots `'00:00'` and `'23:30'` across scheduling, chair matrix, and barber shift availability.
- **T2.2 (Custom Time Format Validation)**:
  - Verifies valid time strings (`'08:15'`, `'19:40'`, `'00:01'`) pass format validation.
  - Verifies invalid formats (`'24:00'`, `'25:00'`, `'12:60'`, `'8:15'`, `'abc'`, `''`) are rejected or sanitized.
- **T2.3 (Duplicate Slot Deduplication)**:
  - Tests adding custom slot `'09:00'` (already present in standard 30-min grid) results in idempotent deduplication.
- **T2.4 (DRE Zero Gross Revenue)**:
  - Tests DRE calculation when gross revenue is R$ 0.00:
    * Net profit = `-fixedCosts`.
    * Margin % = `0.0%` (safe handling of division by zero, no `NaN%` or `Infinity%`).
- **T2.5 (100% vs 0% Commission Extremes)**:
  - Validates commission math when a barber rate is set to 100% (commission = service revenue) or 0% (commission = R$ 0.00).
- **T2.6 (Missing Product Cost Fallback)**:
  - Tests supply cost calculation when an item has undefined or zero cost price, verifying graceful fallback to standard CMV (45% of sale price) without crashing.
- **T2.7 (Empty Collections Handling)**:
  - Tests system stability when collections are empty (`appointments: []`, `barbers: []`, `products: []`, `counterSales: []`).

---

### 4.3 Tier 3: Cross-Feature Interactions
Validates interconnected state transitions and multi-subsystem integrity:
- **T3.1 (Booking with Bar Items + Theme Change + DRE Update)**:
  - Step 1: Client creates appointment with Service (R$ 60,00) + Bar Items (2x Heineken R$ 24,00) = R$ 84,00.
  - Step 2: Client switches theme to Clean Mode (`valverds_theme = 'clean'`).
  - Step 3: Switch to Dono role.
  - Step 4: Verify theme remains Clean Mode (`html.clean-mode`).
  - Step 5: Verify DRE records Service Revenue = R$ 60,00 and Bar Revenue = R$ 24,00.
  - Step 6: Verify Barber commission is calculated strictly on R$ 60,00 (60% = R$ 36,00), NOT on R$ 84,00.
- **T3.2 (Multi-Role Theme Consistency)**:
  - Toggles theme in Site -> switches to Cliente -> Barbeiro -> Recepção -> Dono -> verifies theme class and storage remain strictly synchronized across all views.
- **T3.3 (Counter Sales + Appointment Bar Sales Consolidation)**:
  - Executes a counter sale of R$ 50,00 at reception and an appointment bar item of R$ 30,00.
  - Verifies DRE consolidates total Bar Revenue = R$ 80,00 with R$ 0.00 commission paid.
- **T3.4 (Barber Shift Change Impact on Client Available Slots)**:
  - Barber changes Wednesday shift start time from 09:00 to 11:00.
  - Verifies client booking on Wednesday immediately removes slots 09:00, 09:30, 10:00, and 10:30 from available selection.

---

### 4.4 Tier 4: Real-World Workload Scenarios
Validates end-to-end operational days, full business closeouts, and communication links:
- **T4.1 (Full Operational Day Simulation)**:
  - Simulates a full barbershop business day:
    * 12 total appointments (7 for Luis Valverde, 5 for Yago Barber).
    * 9 completed, 2 pending, 1 canceled.
    * 4 appointments include bar products (Café Espresso, Heineken, Monster).
    * 5 reception counter sales.
  - Asserts:
    * Total Gross Revenue matches strictly completed appointments + counter sales.
    * Pending and canceled appointments are excluded from realized revenue.
    * Luis commission = 60% of his completed services.
    * Yago commission = 50% of his completed services.
    * All bar items are aggregated under Bar Revenue.
    * Net profit and margin percent are calculated with exact cents precision.
- **T4.2 (Barber Shift & WhatsApp Notification Link Generation)**:
  - Barber configures shift hours for Friday (09:00 to 20:00).
  - Client books haircut with phone `(24) 99999-8888`.
  - Verifies generated WhatsApp link matches `https://wa.me/5524999998888?text=...` with proper URL encoding and friendly text.
- **T4.3 (Executive DRE Daily Closeout Reconciler)**:
  - Executes a comprehensive audit closeout against reference oracle:
    * Services: R$ 1,850.00
    * Bar items in appointments: R$ 420.00
    * Counter sales: R$ 260.00
    * Luis services: R$ 1,100.00 -> 60% = R$ 660.00
    * Yago services: R$ 750.00 -> 50% = R$ 375.00
    * Total team commission: R$ 1,035.00
    * Supplies & product cost: R$ 310.00
    * Daily fixed costs: R$ 180.00
    * Derived Net Profit: R$ 1,005.00
    * Derived Net Margin: 39.7%
    * Tolerance: Exact penny equality (0.00 difference).

---

## 5. Coverage Thresholds & Quality Gates

To achieve `TEST_READY` certification, the test suite enforces the following thresholds:

| Tier | Category | Minimum Passing Threshold | Hard Gate Policy |
| :--- | :--- | :--- | :--- |
| **Tier 1** | Feature Coverage (R1–R4) | **100%** | Zero failures permitted on completed milestones |
| **Tier 2** | Boundaries & Corner Cases | **100%** | Zero unhandled exceptions or NaN values |
| **Tier 3** | Cross-Feature Interactions | **100%** | Zero state desynchronization across roles |
| **Tier 4** | Real-World Workload Scenarios | **100%** | Zero penny discrepancy against financial oracle |

---

## 6. Test Suite Directory Structure

```
C:\Users\blaminma\Downloads\valverds-barbershop\
├── TEST_INFRA.md                          # This architecture specification
├── TEST_READY.md                          # Test suite publication & results
└── tests/
    ├── run_e2e_tests.ps1                  # Master CLI test runner
    ├── e2e_test_engine.ps1                # Common test assertions & runner engine
    ├── test_tier1_feature_coverage.ps1    # Tier 1 tests (R1, R2, R3, R4)
    ├── test_tier2_boundaries.ps1          # Tier 2 tests (Edge slots, DRE extremes, NaN guards)
    ├── test_tier3_interactions.ps1        # Tier 3 tests (Theme + Booking + DRE interactions)
    ├── test_tier4_workloads.ps1           # Tier 4 tests (Full day, wa.me, DRE reconciliation)
    └── helpers/
        ├── dre_reference_oracle.ps1       # Authoritative mathematical DRE oracle
        ├── schedule_oracle.ps1            # Authoritative schedule & slot oracle
        └── edge_headless_runner.ps1       # Edge headless DOM & JS execution helper
```

---

## 7. Execution Instructions

### Run All Tests
```powershell
pwsh -File tests/run_e2e_tests.ps1
```

### Run Specific Tier
```powershell
pwsh -File tests/run_e2e_tests.ps1 -Tier 1
pwsh -File tests/run_e2e_tests.ps1 -Tier 2
pwsh -File tests/run_e2e_tests.ps1 -Tier 3
pwsh -File tests/run_e2e_tests.ps1 -Tier 4
```

### Run Specific Milestone Focus
```powershell
pwsh -File tests/run_e2e_tests.ps1 -Milestone M1
pwsh -File tests/run_e2e_tests.ps1 -Milestone M2
pwsh -File tests/run_e2e_tests.ps1 -Milestone M3
pwsh -File tests/run_e2e_tests.ps1 -Milestone M4
```

### Detailed Diagnostic Output
```powershell
pwsh -File tests/run_e2e_tests.ps1 -Detailed
```

Exit code will be `0` when all targeted tests pass, or `1` if any test fails.
