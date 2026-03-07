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