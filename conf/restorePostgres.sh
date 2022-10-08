#!/bin/bash
cat db.sql | docker exec -i postgres psql -U confluence -d confluencedb