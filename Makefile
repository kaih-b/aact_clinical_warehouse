# Start the database
up:
	docker-compose up -d

# Stop the database
down:
	docker-compose down

# Open a SQL shell inside the container
shell:
	docker exec -it aact_postgres psql -U postgres -d aact

# Wipe the database
clean-db:
	docker-compose down -v

# Install Python dependencies
install:
	pip install -r requirements.txt

# Run the ETL pipeline
etl:
	cd src && python etl_loader.py

# Run the validation report
validate:
	cd src && python validate.py

# Build the views and analytics
analytics:
	@echo "Building Views..."
	docker exec -i aact_postgres psql -U postgres -d aact < sql/views/01_vw_industry_sponsors.sql
	docker exec -i aact_postgres psql -U postgres -d aact < sql/views/02_vw_phase3_designs.sql
	docker exec -i aact_postgres psql -U postgres -d aact < sql/views/03_vw_top_sponsors.sql
	@echo "Creating Cumulative Strategic Report..."
	docker exec -i aact_postgres psql -U postgres -d aact < sql/analytics/08_final_competitor_landscape.sql