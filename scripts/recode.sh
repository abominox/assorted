#!/bin/bash

encode_count=0
space_saved=0
totalDuration=0

if [ ! -f /usr/bin/ffmpeg ]; then
  echo "ffmpeg is not installed, exiting..."
  exit 1
fi

if [ -z "$@"  ]; then
  echo "USAGE: recode {file-extension}"
  exit 1
fi

# Find all files with arg extension
IFS=$'\n'
videos=($(find . -maxdepth 1 -name "*.$1"))

# If no files with arg extension exist, exit
if [ -z "${videos[@]}" ]; then
  echo "No video files found in current dir!"
  exit 1
fi

# Confirm selection
echo "Are you sure you would like to re-encode the following files?"
echo "${videos[*]}"
read -rp "Enter y to proceed, anything else to cancel" selection </dev/tty

if [ "$selection" != 'y' ]; then
  exit 0
fi

# Re-encode
for video in "${videos[@]}";
do
  ff_filesize=$(ffprobe -i "${video}" -show_entries format=size -v quiet -of csv="p=0")
  
filesize=$(echo "scale=2; $(echo "$ff_filesize" / 1024 | bc -l)" / 1024 | bc -l)

  ffmpeg -y -i "${video}" -hide_banner -loglevel info -threads "$(nproc --all || 1)" -vcodec libx264 -crf 20 -preset veryfast -vsync 1 -async 1 -c:a copy /tmp/TEMP."$1" && mv -v /tmp/TEMP."$1" "${video}"

  ff_filesize_2=$(ffprobe -i "${video}" -show_entries format=size -v quiet -of csv="p=0")
  converted_size=$(echo "scale=2; $(echo "$ff_filesize_2" / 1024 | bc -l)" / 1024 | bc -l)

  duration=$(echo "scale=2; $(ffprobe -i "${video}" -show_entries format=duration -v quiet -of csv="p=0")" / 60 | bc -l)
  totalDuration=$(echo "$totalDuration + $duration" | bc -l)

  space_saved=$(echo "scale=2; $space_saved + $(echo "scale=2; $filesize - $converted_size" | bc -l)" | bc -l)
  encode_count=$((encode_count+1))
done

# Send report
report_text=\
$(printf "Encode Job for %s\nVideos Encoded: %s\nTotal Minutes: %s\nSpace Saved: %s MiB" \
  "$(pwd)" "$encode_count" "$totalDuration" "$space_saved")

if [ ! -f /usr/local/bin/pb ]; then
  echo "pushbullet-cli is not installed/configured, notification not sent!"
  echo "Please see https://github.com/GustavoKatel/pushbullet-cli"
  echo "$report_text"
else
  pb push "$report_text"
fi
