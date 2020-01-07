#!/bin/bash
# Re-encode middle 40 seconds of argument
# video files as .webm, or whole dir

extensions=("mp4" "avi" "wmv" "flv" "mov" \
"mkv" "divx")

mid_timestamp() {
  duration="$(ffmpeg -i "$1" | grep "Duration"| cut -d ' ' -f 4 | cut -d "," -f 1)"
  hours="$(echo "$duration" | cut -d ":" -f 1)"
  minutes="$(echo "$duration" | cut -d ":" -f 2)"
  seconds="$(echo "$duration" | cut -d ":" -f 3 | cut -d "." -f 1)"

  # If duration less than 40 seconds, do nothing
  if [ "$hours" -eq 00 ] && [ "$minutes" -le 40 ]; then
    return "$duration"
  else
    return "$duration"
  fi
}

if [ ! -f /usr/bin/ffmpeg ]; then
  echo "ffmpeg is not installed, exiting..."
  exit 1
fi

# If no args, re-encode whole dir
if [ -z "$@"  ]; then
  IFS=$'\n'
  files=($(find . -maxdepth 1 -type f))
  for ext in "${extensions[@]}"; do
    for file in "${files[@]}"; do
      if [ "${file##*.}" == "$ext" ]; then
        echo "Re-encoding ---> ${file}"
        ffmpeg -y -i "${file}" -hide_banner -loglevel info -threads \
         "$(nproc --all || 1)" -vcodec libvpx-vp9 -crf 17 -preset veryfast \
         -vsync 1 -async 1 -c:a libvorbis -ss "$(mid_timestamp "${file}")" \
         -t 00:00:40 /tmp/TEMP.webm && mv -v /tmp/TEMP.webm "${file}".webm
      fi
    done
  done        

# if args exist
else
  echo "TEST2"
fi
