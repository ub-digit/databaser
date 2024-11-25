#!/bin/bash

echo "add field is_hidden to alternative_titles"
docker compose exec -it db psql -U postgres -d databases -c 'ALTER TABLE database_alternative_titles ADD COLUMN IF NOT EXISTS is_hidden BOOLEAN DEFAULT FALSE;'
