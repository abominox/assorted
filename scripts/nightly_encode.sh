#!/bin/bash
# Script for a nightly re-encode of selected new
# videos from my storage array, to reduce filesize.
# Texts a report to the user upon completion.
encode_count=0
space_saved=0
totalDuration=0

if [ ! -f /usr/bin/ffmpeg ]; then
  echo "ffmpeg is not installed, exiting..."
  exit 1
fi

# All .mp4 files recursively in current dir, created in last day
IFS=$'\n'
for video in $(find "$@" -mtime +3 -name "*.mp4" -o -name "*.avi" -o -name "*.mov");
do
  # If no .mp4 files, exit
  #[ -f "${video}" ] || echo "No .mp4 files found in current dir!" && break

  ff_filesize=$(ffprobe -i "${video}" -show_entries format=size -v quiet -of csv="p=0")
  filesize=$(echo "scale=2; $(echo "$ff_filesize" / 1024 | bc -l)" / 1024 | bc -l)
  ffmpeg -y -i "${video}" -threads 8 -vcodec libx264 -crf 27 -preset veryfast -vsync 1 -async 1 -c:a copy TEMP.mp4 && mv TEMP.mp4 "${video}"
  ff_filesize_2=$(ffprobe -i "${video}" -show_entries format=size -v quiet -of csv="p=0")
  converted_size=$(echo "scale=2; $(echo "$ff_filesize_2" / 1024 | bc -l)" / 1024 | bc -l)

  duration=$(echo "scale=2; $(ffprobe -i "${video}" -show_entries format=duration -v quiet -of csv="p=0")" / 60 | bc -l)
  totalDuration=$(echo "$totalDuration + $duration" | bc -l)

  space_saved=$(echo "scale=2; $space_saved + $(echo "scale=2; $filesize - $converted_size" | bc -l)" | bc -l)
  encode_count=$((encode_count+1))

  printf "\n\n\nEncode Stats for %s:\nDuration: %s Minutes\nSize Before: %s MiB\nSize After: %s MiB\n" \
    "${video}" "$duration" "$filesize" "$converted_size"
  echo "Encoded $encode_count of ${#video} videos at $(date +"%r on %x")"
done

# Print + send SMS report
report_text=\
$(printf "Nightly Encode Job for %s\nVideos Encoded: %s\nTotal Minutes: %s\nSpace Saved: %s MiB" \
  "$(date +"%A %b. %d")" "$encode_count" "$totalDuration" "$space_saved")

aws sns publish --phone-number="$1" --message "$report_text"
