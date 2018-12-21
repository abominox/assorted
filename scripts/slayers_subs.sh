#!/bin/bash

for ((count = 1; count <= 26; count++)) do
  ffmpeg -y -i Slayers\ ${count}\ \(BDRip\ 960x720\ MKV\,\ AVC\ h264\ 10bit\,\ JP\ AAC\ 48000hz\ 2ch\ 16bit\).mp4 \
    -i Slayers\ ${count}\ EngSub.ass -c:s mov_text -c:v copy -c:a copy TEMP.mp4
  mv -v TEMP.mp4 Slayers\ S1E${count}.mp4
done
