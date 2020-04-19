#!/bin/bash
DIR="$1"

# failsafe - fall back to current directory
[ "$DIR" == "" ] && DIR="."

# save and change IFS
OLDIFS=$IFS
IFS=$'\n'

# read all file name into an array
fileArray=($(find $DIR -type f))

# restore it
IFS=$OLDIFS

# get length of an array
tLen=${#fileArray[@]}

# use for loop read all filenames
for (( i=0; i<${tLen}; i++ ));
do
  filename="${fileArray[$i]}"
  echo $filename
  length=${#filename}
  #echo $length
  line1=""
  line2=""
  for ((j=0; j<=$length; j++));
  do
    if [ $j -lt 10 ]; then
      line1="0$line1"
      line2="$line2$j"
    else
      line1="$line1${j::1}"
      line2="$line2${j:1}"
    fi
  done
  echo $line1
  echo $line2
done
