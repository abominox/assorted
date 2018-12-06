#!/bin/sh
# One-time script to combine external soft-subs
# with episode files for all seasons of Slayers.

COUNT=0
DIR='/mnt/mdrive/videos/anime/Slayers/Season\ 1/'
FILES=($(find "$DIR" -iname "*Slayers*$count*" 2>/dev/null))

while $count <= 26; do
  for file in ${FILES[@]};
  do
    #stuff
  done
done;
