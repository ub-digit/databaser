docker compose exec -it db psql -U postgres -d databases -c 'ALTER TABLE database_terms_of_use ADD COLUMN IF NOT EXISTS has_options boolean DEFAULT true;'