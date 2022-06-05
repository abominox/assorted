#!/bin/bash
# Create thumbnails for all video files in arg directory.
# Generated thumbnails will be placed in the "./thumbnails" subdirectory.
# USAGE: thumbnail.sh <directory>

video_ext=(
".avi" ".mp4" ".mkv" ".mov" ".m4v" \
".mpg" ".mpeg" ".wmv" ".flv" \
".divx" ".webm"
)

# Check for required arg
if [ $# -eq 0 ]; then
    echo "USAGE: thumbnail.sh <directory>"
    exit 1
fi

# If ffmpeg is not installed, exit
if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "ffmpeg is not installed. Exiting."
    exit 1
fi

# If thumbnails dir doesn't exist at target, create it
if [ ! -d "$1"/"thumbnails" ]; then
    mkdir -p "$1"/"thumbnails"
fi

# For each video file in arg directory, create thumbnail
declare -a VIDEOS=()
shopt -s globstar nullglob
for ext in "${video_ext[@]}"; do
    for file in "$1"/**/*"$ext"; do
        VIDEOS+=("$file")
    done

    # Create thumbnails for each found video file with ffmpegthumbnailer
    for video_path in "${VIDEOS[@]}"; do
        # Strip get last part of path and strip out extension
        file_name="$(basename "$video_path")"
        file_name="$(echo "$file_name" | cut -f 1 -d '.')"

        ffmpegthumbnailer -q 10 -c png -s 512 -t 50 -i "$video_path" -o "$1""/thumbnails/""$file_name"".png"
        echo "Thumbnail Created: ""$1""/thumbnails/""$file_name"".png"
    done

    # Clear array when finished before looking for next extension
    VIDEOS=()
done