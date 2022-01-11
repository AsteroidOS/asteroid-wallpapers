#!/bin/bash

# Scale and compress all jpg, jpeg, png, svg, bmp and webp images to existing preview resolution folders

if ! command -v mogrify &> /dev/null
then
    echo "
$(tput setaf 1)mogrify could not be found. Install mogrify (Image Magick) from your package manager.$(tput sgr0)"
    exit
else
    echo "
$(tput setaf 2)mogrify found, proceeding...$(tput sgr0)
         "
fi

unset options i
while read -r -d $'\0' dir
do
  if [ ! $dir = "full/" ]
  then
    options[i++]="$dir"
  fi
done < <(find */ -maxdepth 0 -type d -print0 )

for file in *.{jpg,jpeg,png,svg,bmp,webp}; do
  if [ ! -f $file ]
  then
    echo "$(tput setaf 214)No $file files present.$(tput sgr0)"
  else
    mogrify -resize 480x480 -quality 80 -format jpg -path full $file
    echo "480px full wallpaper generated for $file."
    for opt in "${options[@]}"
    do
      mogrify -resize ${opt::-1}x${opt::-1} -quality 55 -format jpg -path ${opt::-1} $file
      echo "${opt::-1}px preview generated for $file."
    done
  fi
  echo "
$(tput setaf 2)All scaled and compressed images for $file generated succesfully.$(tput sgr0)
       "
done
