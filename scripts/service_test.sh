#!/bin/sh
# Test homelab services every 2 hours
# and notify of results.

report_text="Bi-Hourly Homelab Services Report for $(date +"%r on %x")"

services=(

)

### HTPC Stack
# Plex
if curl -s --max-time 5 http://192.168.1.3:32400/web/index.html; then
  report_text+="[/] Plex is up\n"
else
  report_text+="[/] Plex is up\n"
fi
# Sonarr
if curl -s 
