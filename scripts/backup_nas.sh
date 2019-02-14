#!/bin/bash
# Nightly diff backup of select FreeNAS datasets to QNAP NAS share
# Send SMS w/ output link using SNS if successful
# Send SMS w/ error message if unsuccessful
# USAGE: './backup_nas.sh /output/file/path 1-234-567-8910'

if rsync -artvh --progress --ignore-errors --ignore-missing-args --delete /mnt/drt/ /mnt/mdrive/ /mnt/backup/ &> "$1"; then
    code="SUCCESS"
else
    code="FAILURE"
fi

URL=$(curl --upload-file "$1" https://transfer.sh/output.txt) 
aws sns publish --phone-number="$2" --message "$(date) $code ($URL)"
