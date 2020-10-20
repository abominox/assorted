#!/bin/bash
# Nightly diff backup of select FreeNAS datasets to QNAP NAS share & offsite backup
# Send SMS w/ output link if successful
# Send SMS w/ error message if unsuccessful

backup () {
  touch /tmp/"$3".txt && output_file=/tmp/"$3".txt || output_file=/dev/null

  printf "%s\n\n" "($3) Daily Differential Backup for $(date +"%A %b %d, %Y")" > "$output_file"

  if rsync -e "ssh -p $4" --stats -ahv --relative --ignore-errors --ignore-missing-args \
   --exclude @Recycle \
   --delete \
   /mnt/./drt \
   /mnt/./mdrive \
   raxemremy@"$2" &>> "$output_file"; then
    code="SUCCESS"
  else
    code="FAILURE"
  fi

  transfer_size="Transfer Size: "$(grep "Literal data: " "$output_file" | cut -d " " -f 3)
  new_files="New Files Created: "$(grep "Number of created files: " "$output_file" | cut -d " " -f 5)
  deleted_files="Deleted Files: "$(grep "Number of deleted files: " "$output_file" | cut -d " " -f 5)

  pb push "($3) Backup for $(date) $code $(printf "\n%s\n%s\n%s" \
    "$transfer_size" \
    "$new_files" \
    "$deleted_files" \
    )"

  pb push --file "$output_file"
  rm "$output_file"
}

#backup "$1" "192.168.1.12:/share/backup" "LOCAL" "22"
backup "$1" "castlemarquart.hopto.org:/offsite" "OFFSITE" "25200"
