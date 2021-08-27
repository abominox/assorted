#!/bin/sh
# Setup a temporary, 20 minute scratch server for testing.

api_key="XXXXXXXXXXXXXXXXXXXXXXXXXXXX"

# If arg exists, keep the server indefinitely by killing existing script PID.
if [ ! -z "$1" ]; then
  echo "todo"
fi

#####

# Create server
#curl -H "API-Key: $api_key" https://api.vultr.com/v1/server/create --data 'DCID=6' --data 'VPSPLANID=201' --data 'OSID=352'

# Query server info
curl -H "API-Key: $api_key" https://api.vultr.com/v1/server/list
