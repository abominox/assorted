#!/bin/bash
# Nightly diff backup of select FreeNAS datasets to QNAP NAS share
# Send SMS w/ output link using SNS if successful
# Send SMS w/ error message if unsuccessful
# USAGE: './backup_nas.sh /output/file/path 1-234-567-8910'

# If no args, print usage
if [ $# -eq 0 ]; then
  echo "USAGE: './backup_nas.sh /output/file/path 1-234-567-8910'"
  exit 1
fi

printf "%s\n\n" "Daily Differential Backup for $(date +"%A %b %d, %Y")" > "$1"

if rsync -avP --relative --ignore-errors --ignore-missing-args --exclude @Recycle --delete /mnt/./drt /mnt/./mdrive raxemremy@192.168.1.12:/share/Backup &>> "$1"; then
    code="SUCCESS"
else
    code="FAILURE"
fi

URL=$(curl --upload-file "$1" https://transfer.sh/output.txt) 
#URL=$(pastebinit -P -i "$1" -a "anonymous" -b http://pastebin.com)
#aws sns publish --phone-number="$2" --message "$(date) $code ($URL)"
pb push "$(date) $code ($URL)"
