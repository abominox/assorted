#!/bin/bash

# This script gets called every morning at 6 am in cron and leverages the FileBot CLI  to ensure that my media
# collection is properly labeled and all files are organized in the correct folders.

# Anime
# check for new anime torrents, move to correct directory
filebot -rename -r --db anidb "/mnt/mdrive/torrents" --output /mnt/mdrive/videos/anime --format "{n}/Season {s}/{sxe} - {t}"
# correct all episode titles
filebot -r -rename /mnt/mdrive/videos/anime --db anidb -non-strict --format "{n}/Season {s}/{sxe} - {t}"

# TV Shows
filebot -rename -non-strict -r --db TheTVDB "/mnt/mdrive/torrents" --output /mnt/mdrive/videos/tv --format "{n}/Season {s}/{sxe} - {t}"

# Movies
filebot -rename -non-strict --db themoviedb -r "/mnt/mdrive/torrents" --output /mnt/mdrive/videos/movies --format "{n}"
