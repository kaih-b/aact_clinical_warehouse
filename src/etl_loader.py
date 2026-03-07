import pandas as pd
from sqlalchemy import create_engine
import os
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')

# Database connection string (matches docker-compose.yml)
DB_USER = 'postgres'
DB_PASSWORD = '5236'
DB_HOST = 'localhost'
DB_PORT = '5432'
DB_NAME = 'aact'
engine = create_engine(f'postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}')

# Function to load each table with a known filename
def load_table(file_name, table_name):
    file_path = f'../data/{file_name}'
    
    if not os.path.exists(file_path):
        logging.error(f"File not found: {file_path}")
        return

    logging.info(f"Extracting {file_name}...")
    
    # Extract table info; handle different data types
    df = pd.read_csv(file_path, sep='|', low_memory=False)
    
    # Transform data (nothing yet; cleaning would go here)
    logging.info(f"Transforming data: Found {len(df)} rows.")

    # Push to PostgreSQL docker in matches to prevent memory crashes from above low_memory selection
    logging.info(f"Loading into table '{table_name}' in batches...")
    df.to_sql(table_name, engine, if_exists='replace', index=False, chunksize=10000)
    
    logging.info(f"Success! {table_name} loaded.\n")

if __name__ == '__main__':
    logging.info("Starting AACT ETL Pipeline...")
    
    load_table('studies.txt', 'studies')
    load_table('sponsors.txt', 'sponsors')
    load_table('interventions.txt', 'interventions')
    load_table('designs.txt', 'designs')
    
    logging.info("ETL Pipeline Complete.")