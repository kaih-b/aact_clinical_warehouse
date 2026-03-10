import pandas as pd
from sqlalchemy import create_engine
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

# Database connection
engine = create_engine('postgresql://postgres:1234@localhost:5432/aact')

def export_for_tableau():
    export_dir = '../export'
    
    # Create the export folder
    if not os.path.exists(export_dir):
        os.makedirs(export_dir)
        logging.info(f"Created directory: {export_dir}")
    
    # Point to cumulative analytics query
    sql_file_path = '../sql/analytics/08_final_competitive_landscape.sql'
    
    # Simple exception handling
    if not os.path.exists(sql_file_path):
        logging.error(f"Cannot find SQL file at {sql_file_path}")
        return

    logging.info("Reading cumulative analytics SQL...")
    with open(sql_file_path, 'r') as file:
        query = file.read()
    
    logging.info("Executing query in PostgreSQL...")
    df = pd.read_sql(query, engine)
    
    output_path = f'{export_dir}/competitor_data.csv'
    
    logging.info("Saving data to CSV...")
    df.to_csv(output_path, index=False)
    
    logging.info(f"Success! Exported {len(df)} rows to {output_path}")

if __name__ == '__main__':
    print("\nInitiating Tableau Data Export!\n")
    export_for_tableau()