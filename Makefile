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