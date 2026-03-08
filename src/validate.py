import pandas as pd
from sqlalchemy import create_engine
import logging

# Set up logging to match ETL loader
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

engine = create_engine('postgresql://postgres:1234@localhost:5432/aact')

def run_validation():
    print("--- DATA WAREHOUSE VALIDATION REPORT ---")
    
    # Counts rows in each table
    tables = ['studies', 'sponsors', 'interventions', 'designs']
    for table in tables:
        count = pd.read_sql(f"SELECT COUNT(*) FROM {table}", engine).iloc[0,0]
        print(f"{table.ljust(15)}: {count:,} rows")

    # Checks for foreign key orphans (e.g. are there sponsors, interventions, or designs without a study linked)
    child_tables = [table for table in tables if table != 'studies']
    
    for table in child_tables:
        orphan_query = f"""
            SELECT COUNT(*) 
            FROM {table} 
            LEFT JOIN studies ON {table}.nct_id = studies.nct_id 
            WHERE studies.nct_id IS NULL;
        """
        orphans = pd.read_sql(orphan_query, engine).iloc[0,0]
        
        if orphans > 0:
            print(f"WARNING: Found {orphans:,} orphaned records in '{table}'.")
        else:
            print(f"PASSED: '{table}' has 0 orphans.")

if __name__ == '__main__':
    run_validation()