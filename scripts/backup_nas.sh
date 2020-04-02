#!/bin/bash
# Nightly diff backup of select FreeNAS datasets to QNAP NAS share & offsite backup
# Send SMS w/ output link if successful
# Send SMS w/ error message if unsuccessful

backup () {
  touch /tmp/"$3".txt && output_file=/tmp/"$3".txt || output_file=/dev/null

  printf "%s\n\n" "($3) Daily Differential Backup for $(date +"%A %b %d, %Y")" > "$output_file"

  if rsync -av --relative --ignore-errors --ignore-missing-args \
   --exclude @Recycle \
   --delete \
   /mnt/./drt \
   /mnt/./mdrive \
   raxemremy@"$2" &>> "$output_file"; then
    code="SUCCESS"
  else
    code="FAILURE"
  fi

  pb push "($3) Backup for $(date) $code $(printf "\n%s" "$URL")"
  pb push --file "$output_file"
  rm "$output_file"
}

backup "$1" "192.168.1.12:/share/backup" "LOCAL"
backup "$1" "castlemarquart.hopto.org:/offsite" "OFFSITE"
