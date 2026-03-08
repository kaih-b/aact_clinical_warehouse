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