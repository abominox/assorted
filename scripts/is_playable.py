"""is_playable.py: Prints out which video files in a given directory are not playable/corrupt."""
#!/usr/bin/env python3

import os
import sys
import subprocess as sp

def main():
    """Main"""
    video_ext = ["mp4", "avi", "wmv", "flv", "mov", "mkv", "divx"]
    videos = []

    # Did user pass input directory?
    if len(sys.argv) < 2:
        print("Usage: is_playable.py <directory>")
        sys.exit(1)

    # Is ffprobe installed?
    try:
        sp.check_call(["ffprobe", "--help"], stdout=sp.DEVNULL, stderr=sp.DEVNULL)
    except sp.CalledProcessError:
        print("ffprobe is not installed.")
        sys.exit(1)

    # Is directory valid?
    directory = sys.argv[1]
    if not os.path.isdir(directory):
        print(f"{directory} is not a valid directory")
        sys.exit(1)

    # Collect paths of all video files in passed directory
    for path in os.listdir(directory):
        abspath = os.path.join(directory, path)
        if os.path.isfile(abspath):
            if path.split(".")[-1] in video_ext:
                videos.append(abspath)

    # Check if each video file is playable
    for video in videos:
        if is_corrupt(video):
            print(video)

    sys.exit(0)

def is_corrupt(video: str) -> bool:
    """Check if a single video is corrupted (not playable)"""
    try:
        sp.check_call(["ffprobe", "-i", video], stdout=sp.DEVNULL, stderr=sp.DEVNULL)
    except sp.CalledProcessError:
        return True

    # If no error, video file is not corrupt
    return False

main()
