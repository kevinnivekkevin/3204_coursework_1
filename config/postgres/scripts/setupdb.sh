#!/bin/bash
psql -U confluence -d confluencedb -f /vagrant/config/postgres/db.sql
psql -U confluence -d confluencedb -f /vagrant/config/postgres/update.sql
