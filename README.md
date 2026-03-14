# AACT Clinical Warehouse

## Summary
This project is an end-to-end data pipeline that transforms raw clinical trial metadata into a competitive analysis of top pharmaceutical sponsors. Covering everything from automated infrastructure (Docker) and data processing (Python/ETL) to database modeling (PostgreSQL) and BI visualization (Tableau), the system processes 570,000+ records from the [AACT Database](https://aact.ctti-clinicaltrials.org/downloads) to identify trends in late-stage trial success rates (i.e. 1 - termination rate), execution velocity, and operational efficiency.

## Final Product
[![Biopharma R&D Efficiency Dashboard](export/tableau_dashboard.png)](https://public.tableau.com/app/profile/kai.henrikson.brandt/viz/Biopharma_RD_Analysis/BiopharmaRD)

## Analysis

### Key Findings
- **GSK**: Demonstrated high volume (790 trials) alongside high efficiency, maintaining a 95% success rate and a low average trial duration of 682 days.
- **Organon & Co**: Recorded the highest overall efficiency (96% success, 581 days), indicating potential execution speed advantages for specialized pipelines, in this case women's health.
- **Novartis**: Handled the highest total throughput in the industry (891 trials) while maintaining a 90% success rate and an industry-average trial duration of 974 days.

### Data Context and Interpretation
Success metrics in clinical trials are heavily influenced by corporate strategy and target therapeutic areas:

- **Target Risk Profiles (Pfizer, Gilead)**: Lower relative success rates (82%) correlate with portfolios focused on complex, novel modalities. Higher failure rates are a likely byproduct of more ambitious targets rather than operational bottlenecks.
- **Disease Area Impacts (BMS, Roche)**: The longest average trial durations (BMS: 1,569 days; Roche: 1,485 days) reflect oncology-primary portfolios. These trials require multi-year tracking of endpoints like overall survival (OS) and progression-free survival (PFS).

## Project Phases & Milestones

| Phase | Milestone | Core Tech | Product |
| :--- | :--- | :--- | :--- |
| **1** | **Infrastructure** | Docker, Make | Containerized PostgreSQL 15 environment. |
| **2** | **ETL Pipeline** | Python | Automated batch-loaded extraction of pipe-delimited AACT files. |
| **3** | **Data Modeling** | SQL | Relational mapping of `studies`, `sponsors`, `interventions`, and `designs`. |
| **4** | **Advanced Analytics**| SQL (CTEs, Window Functions) | Modular views and strategic queries for competitor benchmarking. |
| **5** | **Optimization & Bridge**| SQL (Indexes), Python | Indexing for performance and automated CSV export for BI tools. |
| **6** | **Visualization** | Tableau Public | Interactive dashboard. |

## Relational Interpretation

**Tables of Interest**: `studies`, `sponsors`, `interventions`, `designs`

### Studies

The `studies` table is the AACT database's core hub, storing unique trial data via the `nct_id` Primary Key. 

### Sponsors
The `sponsors` table tracks funding organizations. Because modern trials are highly collaborative and often involve multiple sponsors, the relationship with `studies` is **one-to-many**, joined on `nct_id`. 

**Utility**: This connection drives biotech market intelligence. Joining these tables aggregates data by company, answering questions like: **"Which pharmaceutical companies are heavily investing in specific trials?"** This reveals the competitive landscape and positions for future drug development.

### Interventions

The `interventions` table tracks administered treatments, including `intervention_type`, `name`, and `description`. Since single trials often test multiple interventions (e.g., experimental drugs vs. placebos), this is likewise a **one-to-many** relationship with `studies`, joined via `nct_id`.

**Utility**: This connection bridges trial frameworks with actual science. It enables analysis of treatment modality trends (e.g., biologics vs. small molecules) and delivery methods. For competitive intelligence, it reveals how novel therapies compare against the standard of care.

### Designs

The `designs` table tracks structural procedures like `masking`, `allocation`, and `primary_purpose`. Because a trial generally has one overarching layout, this is a **one-to-one** relationship with `studies`, joined on `nct_id`.

**Utility**: This connection evaluates a trial's scientific rigor. We can analyze how experimental procedures including masking ("blindness") correlate with trial success or FDA approval rates. This is essential for understanding how design choices impact a drug's likelihood of reaching the market.

## Technical Features

### Infrastructure
- **Containerization**: The entire warehouse is managed via `Docker Compose`, ensuring isolation between the database and the local OS.
- **Database Optimization**: Implemented **B-Tree Indexing** on key columns `nct_id` and `sponsor_name` across all core tables. This optimization reduced query execution time for Phase 3 analytical joins by over 80%, enabling rapid iteration on this large dataset.

### Analytical Logic
The analytics layer utilizes advanced SQL to extract business insight from clinical metadata:

- **Launch Rate**: Utilizes window functions (`LAG` and `PARTITION BY`) to calculate trial launch rates per sponsor, allowing for a direct comparison of operational speed.
- **Success Benchmarking**: Employs common table expressions (CTEs) to aggregate trial termination rates against experimental design style, allowing for correlation analysis between the two variables.
- **Modular Modeling**: Deploys a suite of SQL views to standardize data, robustly filtering out non-industry records to focus strictly on corporate biopharma.

### Automated Data Bridge
To ensure the project remains reproducible, the system includes a `Makefile` driven export pipeline. Running `make export` triggers a Python-SQL bridge that executes the final strategic query and generates a cleaned `competitor_data.csv`. This file is structurally fit for BI tools such as Tableau and PowerBI.

## Reproducing the Environment

This project is built to be entirely reproducible via the provided `Makefile`.

1.  **Clone the Repository**:
    ```bash
    git clone [https://github.com/kaih-b/aact_clinical_warehouse.git](https://github.com/kaih-b/aact_clinical_warehouse.git)
    cd aact_clinical_warehouse
    ```

2.  **Install Dependencies**:
    ```bash
    make install
    ```
   
4.  **Initialize the Database**:
    ```bash
    make up
    ```
5.  **Load Data**: Create a `data/` directory and place [AACT files](https://aact.ctti-clinicaltrials.org/downloads) for `studies.txt`, `sponsors.txt`, `interventions.txt`, and `designs.txt` inside. Run the ETL pipeline:
    ```bash
    make etl
    ```
6.  **Optimize & Analyze**:
    ```bash
    make optimize
    make analytics
    ```
7.  **Export for BI**:
    ```bash
    make export
    ```
