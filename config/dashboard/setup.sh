#!/bin/bash
cd /home

# Copy pre-configured project board into the project directory
cp /vagrant/config/dashboard/project_board.ndjson .
curl -X POST "http://127.0.0.1:5601/api/saved_objects/_import?createNewCopies=true" -H "kbn-xsrf: true" --form file=@project_board.ndjson