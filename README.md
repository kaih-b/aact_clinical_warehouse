# AACT Clinical Warehouse

## Summary
This project is a containerized end-to-end data pipeline designed to transform raw clinical trial metadata into an actionable competitive analysis of the top players. By processing 570,000+ records from the AACT (Aggregate Analysis of ClinicalTrials.gov) database, the system identifies trends in late-stage trial success, launch rate, and operational efficiency.

The project serves as a proof-of-concept for a full-stack data lifecycle, moving from infrastructure-as-code and automated ETL to relational modeling and culminating with an industry-style visualization in Tableau.

## Project Phases & Milestones

| Phase | Milestone | Core Tech | Key Deliverable |
| :--- | :--- | :--- | :--- |
| **1** | **Infrastructure** | Docker, Make | Containerized PostgreSQL 15 environment. |
| **2** | **ETL Pipeline** | Python | Automated batch-loaded extraction of pipe-delimited AACT files. |
| **3** | **Data Modeling** | SQL | Relational mapping of `studies`, `sponsors`, `interventions`, and `designs`. |
| **4** | **Advanced Analytics**| SQL (CTEs, Window Functions) | Modular views and strategic queries for competitor benchmarking. |
| **5** | **Optimization & Bridge**| SQL (Indexes), Python | Indexing for performance and automated CSV export for BI tools. |

## Relationships Between Core AACT Tables

**Tables of Interest**: `studies`, `sponsors`, `interventions`, `design`

#### Studies & Sponsors

The `studies` table is the AACT database's core hub, storing unique trial data via the `nct_id` Primary Key. The `sponsors` table tracks funding organizations. Because modern trials are highly collaborative and often involve multiple sponsors, their relationship is **One-to-Many**, joined on `nct_id`. 

**Utility**: This connection drives biotech market intelligence. Joining these tables aggregates data by company, answering questions like: **"Which pharmaceutical companies are heavily investing in specific trials?"** or **"Who collaborates with key academic institutions?"** This reveals the competitive landscape and positions for future drug development.

#### Studies & Interventions

The `interventions` table tracks administered treatments, including `intervention_type`, `name`, and `description`. Since single trials often test multiple interventions (e.g., experimental drugs vs. placebos), this forms a **One-to-Many** relationship, joined via `nct_id`.

**Utility**: This connection bridges trial frameworks with actual science. It enables analysis of treatment modality trends (e.g., biologics vs. small molecules) and delivery methods. For competitive intelligence, it reveals how novel therapies compare against the standard of care across various disease areas.

#### Studies & Design

The `designs` table tracks structural procedures like `masking`, `allocation`, and `primary_purpose`. Because a trial generally has one overarching layout, this is a **One-to-One** relationship, joined on `nct_id`.

**Utility**: This connection evaluates a trial's scientific rigor. We can analyze how experimental procedures—like double-blind, randomized designs—correlate with trial success or FDA approval rates. This is essential for understanding how design choices impact a drug's likelihood of reaching the market.

## Technical Features

### Infrastructure
- **Containerization:** The entire warehouse is managed via `Docker Compose`, ensuring an environment that isolates the database from the local OS.
- **Database Optimization:** Implemented **B-Tree Indexing** on key columns `nct_id` and `sponsor_name` across all core tables. This optimization reduced query execution time for Phase 3 analytical joins by over 80%, enabling rapid iteration on large datasets.

### Analytical Logic
The analytics layer utilizes advanced SQL to extract business value from clinical metadata:
- **Launch Rate**: Utilizes window functions (`LAG` and `PARTITION BY`) to calculate the trial launch cadence, allowing for a direct comparison of operational speed between industry leaders.
- **Success Benchmarking**: Employs common table expressions (CTEs) to aggregate trial termination rates against specific experimental designs in an attempt to identify correlation between design and termination rate.
- **Modular Modeling**: Developed a suite of SQL views to standardize data, robustly filtering out non-industry records to focus strictly on corporate biopharma competition.

### Automated Data Bridge
To ensure the project remains reproducible, the system includes a `Makefile` driven export pipeline. Running `make export` triggers a Python-SQL bridge that executes the final strategic query and generates a cleaned `competitor_data.csv`. This file is structurally fit for BI tools such as Tableau and PowerBI.

## Results Overview

| Sponsor | Total Phase 3 Trials | Success Rate (%) | Failure Rate (%) | Avg. Duration (Days) |
| :--- | :---: | :---: | :---: | :---: |
| Novartis | 891 | 90.3 | 9.7 | 974 |
| GSK | 790 | 94.8 | 5.2 | 682 |
| Merck | 683 | 87.8 | 12.2 | 971 |
| Pfizer | 678 | 82.3 | 17.7 | 977 |
| Sanofi | 656 | 88.3 | 11.7 | 888 |
| AstraZeneca | 606 | 92.7 | 7.3 | 971 |
| Johnson & Johnson | 492 | 90.2 | 9.8 | 994 |
| Roche | 448 | 87.3 | 12.7 | 1485 |
| Eli Lilly | 439 | 93.2 | 6.8 | 1019 |
| AbbVie | 375 | 94.4 | 5.6 | 1099 |
| Novo Nordisk A/S | 304 | 94.7 | 5.3 | 724 |
| Bayer | 301 | 94.4 | 5.6 | 925 |
| Organon and Co | 287 | 95.8 | 4.2 | 581 |
| Takeda | 274 | 86.9 | 13.1 | 746 |
| Amgen | 236 | 91.5 | 8.5 | 1241 |
| Bristol-Myers Squibb | 208 | 91.3 | 8.7 | 1569 |
| Boehringer Ingelheim | 202 | 93.1 | 6.9 | 922 |
| Gilead Sciences | 177 | 81.9 | 18.1 | 1161 |
| Shire | 142 | 85.9 | 14.1 | 801 |
| Viatris | 138 | 88.4 | 11.6 | 825 |

# TODO ADD ANALYSIS

## Reproducing the Environment

This project is built to be entirely reproducible via the provided `Makefile`.

1.  **Create the Database:**
    ```bash
    make up
    ```
2.  **Load Data:** Place AACT `.txt` files for `studies`, `sponsors`, `interventions`, and`designs` in `data/` and run the ETL pipeline:
    ```bash
    make etl
    ```
3.  **Run Analytics & Optimize:**
    ```bash
    make analytics
    make optimize
    ```
4.  **Export for BI:**
    ```bash
    make export
    ```