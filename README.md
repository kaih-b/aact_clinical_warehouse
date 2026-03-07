# AACT Clinical Trials Data Warehouse

# Overview & Objective
This project is a containerized PostgreSQL data warehouse built to analyze clinical trial data from the Aggregate Analysis of ClinicalTrials.gov (AACT) database. The objective is to gain experience in industry-standard data analytics workflows.

The project is designed to demonstrate full-cycle data engineering skills, including infrastructure-as-code (Docker), database management, ETL (Python), and SQL (Window Functions, CTEs, Indexing).

## Tech Stack
* **Database:** PostgreSQL 15
* **Infrastructure:** Docker & Docker Compose
* **Automation:** GNU Make
* **Analytics:** SQL

## Reproducing the Environment

This project is built to be entirely reproducible. To spin up the database locally:

1. Clone this repository.
2. Ensure Docker Desktop is running.
3. Run the following command to build and start the database:
   ```bash
   make up

To run the ETL pipeline locally, download the AACT static files (`.txt`), create a `data/` directory in the root folder, and place the `.txt` files inside it before running `make etl`.

## Relationships Between Core Tables

**Tables of interest:** `studies`, `sponsors`, `interventions`, `designs`

#### Studies & Sponsors

The `studies` table sits at the core of the AACT database as the central hub for all clinical trials. Its Primary Key is the `nct_id` (National Clinical Trial Identifier), meaning every single trial has one unique row containing high-level data like the trial's phase, overall status, and start date.

The `sponsors` table tracks the organizations funding each trial. Modern clinical research is highly collaborative, meaning each trial often has multiple sponsors. Therefore, the relationship is **One-to-Many**. 

We connect these tables by joining the `nct_id` Primary Key in the `studies` table to the `nct_id` Foreign Key in the `sponsors` table. 

**Utility**: This connection is critical for biotech market intelligence and corporate strategy. Mastering this join allows us to aggregate trial data by company to answer high-value questions like: **"Which pharmaceutical companies are heavily investing in a certain type of trial this year?"** or **"Which corporations most commonly collaborate with a specific academic institution and why?"** These questions are key in developing a deeper understanding of the biotech landscape, identifying market stakes, and positioning for future drug development success.

#### Studies & Interventions

The `interventions` table tracks the specific medical interventions administered in each trial, including `intervention_type` (e.g., Drug, Device, Biological), `name`, and `description`. Because a single trial often tests multiple interventions (e.g., an experimental drug vs. a placebo, or a combination therapy), this is a **One-to-Many** relationship. It is connected to the studies table by joining the `nct_id` keys.

**Utility**: This connection bridges the gap between the trial framework and the actual science. It allows us to analyze trends in treatment modalities (e.g., the rise of biologics vs. small molecules) or delivery methods (intravenous vs. oral). From a competitive intelligence standpoint, this allows us to track how novel therapies stack up against the current "Standard of Care" across different disease areas.

#### Studies & Design

The `designs` table tracks the structural and experimental procedure for each trial, including `masking` (who is blind to the treatment), `allocation` (how patients are assigned to groups), and `primary_purpose` (e.g., Treatment, Prevention, Diagnostic). Because a trial generally has one overarching architectural layout, this is typically a **One-to-One** relationship, joined on the `nct_id`.

**Utility**: This connection allows us to evaluate the scientific rigor and statistical power of the trials. We can analyze the relationships between experimental procedures—such as double-blind, randomized designs—and trial success or FDA approval rates. It is essential for understanding how trial design choices impact the likelihood of a drug reaching the market.
