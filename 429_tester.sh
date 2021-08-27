#!/bin/bash
# Test selected endpoint for rate limiting

counter=0

while true
do
  STATUS="$(curl -s -o /dev/null -w '%{http_code}' "$1")"
  counter="$((counter+1))"
  printf "\nSent 1 request at %s" "$(date +"%Y-%m-%d %H:%M:%S:%3N")"
  if [ "$STATUS" -eq 429 ]; then
    printf "\n\n\nGot a 429 response after %s requests.\n" "$counter"
    break
  fi
done
