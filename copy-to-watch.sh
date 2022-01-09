#!/bin/bash

# Copy content of the image folders to a connected watch

unset options i
while read -r -d $'\0' dir
do
  scp $dir* root@192.168.2.15:/usr/share/asteroid-launcher/wallpapers/$dir
done < <(find */ -maxdepth 0 -type d -print0 )
