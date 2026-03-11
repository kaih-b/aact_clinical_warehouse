# AACT Clinical Warehouse

## Summary
This project is a containerized end-to-end data pipeline designed to transform raw clinical trial metadata into an actionable competitive analysis of the top players. By processing 570,000+ records from the AACT (Aggregate Analysis of ClinicalTrials.gov) database, the system identifies trends in late-stage trial success, launch rate, and operational efficiency.

The project serves as a proof-of-concept for a full-stack data lifecycle, moving from infrastructure-as-code and automated ETL to relational modeling and culminating with an industry-style visualization in Tableau.

## Project Progress & Architecture

| Phase | Milestone | Core Tech | Key Deliverable |
| :--- | :--- | :--- | :--- |
| **1** | **Infrastructure** | Docker, Make | Containerized PostgreSQL 15 environment. |
| **2** | **ETL Pipeline** | Python | Automated batch-loaded extraction of pipe-delimited AACT files. |
| **3** | **Data Modeling** | SQL | Relational mapping of `studies`, `sponsors`, `interventions`, and `designs`. |
| **4** | **Advanced Analytics**| SQL (CTEs, Window Functions) | Modular views and strategic queries for competitor benchmarking. |
| **5** | **Optimization & Bridge**| SQL (Indexes), Python | Indexing for performance and automated CSV export for BI tools. |

## Technical Features

### Infrastructure
* **Containerization:** The entire warehouse is managed via `Docker Compose`, ensuring an environment that isolates the database from the local OS.
* **Database Optimization:** Implemented **B-Tree Indexing** on key columns `nct_id` and `sponsor_name` across all core tables. This optimization reduced query execution time for Phase 3 analytical joins by over 80%, enabling rapid iteration on large datasets.

### Analytical Logic
The analytics layer utilizes advanced SQL to extract business value from clinical metadata:
* **Launch Rate**: Utilizes window functions (`LAG` and `PARTITION BY`) to calculate the trial launch cadence, allowing for a direct comparison of operational speed between industry leaders.
* **Success Benchmarking**:Employs common table expressions (CTEs) to aggregate trial termination rates against specific experimental designs in an attempt to identify correlation between design and termination rate.
* **Modular Modeling**: Developed a suite of SQL viewsto standardize data, robustly filtering out non-industry records to focus strictly on corporate biopharma competition.

### 3. Automated Data Bridge
To ensure the project remains reproducible, the system includes a `Makefile` driven export pipeline. Running `make export` triggers a Python-SQL bridge that executes the final strategic query and generates a cleaned `competitor_data.csv`. This file is structurally fit for BI tools such as Tableau and PowerBI.

## Results Overview

| Sponsor | Total Phase 3 Trials | Success Rate (%) | Failure Rate (%) | Avg. Duration (Days) |
| :--- | :---: | :---: | :---: | :---: |
| GlaxoSmithKline | 790 | 94.8 | 5.2 | 682 |
| AstraZeneca | 606 | 92.7 | 7.3 | 971 |
| Merck Sharp & Dohme LLC | 601 | 88.5 | 11.5 | 974 |
| Pfizer | 560 | 80.7 | 19.3 | 1038 |
| Novartis Pharmaceuticals | 558 | 86.4 | 13.6 | 1238 |
| Sanofi | 448 | 86.4 | 13.6 | 885 |
| Hoffmann-La Roche | 448 | 87.3 | 12.7 | 1485 |
| Eli Lilly and Company | 439 | 93.2 | 6.8 | 1019 |
| Novo Nordisk A/S | 304 | 94.7 | 5.3 | 724 |
| Bayer | 301 | 94.4 | 5.6 | 925 |
| Organon and Co | 287 | 95.8 | 4.2 | 581 |
| Takeda | 274 | 86.9 | 13.1 | 746 |
| Novartis | 251 | 96.0 | 4.0 | 566 |
| Amgen | 236 | 91.5 | 8.5 | 1241 |
| Bristol-Myers Squibb | 208 | 91.3 | 8.7 | 1569 |
| Boehringer Ingelheim | 202 | 93.1 | 6.9 | 922 |
| AbbVie | 189 | 94.2 | 5.8 | 1207 |
| Johnson & Johnson (R&D) | 182 | 92.9 | 7.1 | 885 |
| Gilead Sciences | 177 | 81.9 | 18.1 | 1161 |
| Shire | 142 | 85.9 | 14.1 | 801 |

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