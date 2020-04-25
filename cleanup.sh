#!/bin/bash

setvars () {
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
    # set a leave switch
    leavealone=''
}

rename () {
  #echo $newname
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo \"$filename\"" "\"$newname\"
    mv "${filename}" "${newname}"
  fi
}

getcutoff () {
  echo What character should I cut from?
  read cutposition
  if [ -z $cutposition ]; then
    #probably a single word film
    newname=$displayname$fileext
    echo "File will be renamed:"$newname
  else
    #cut the extra text
    newname=${displayname::$cutposition}
    newname=${newname//./ }
    newname=$newname$fileext
    echo "File will be renamed:"$newname
  fi
}

displaycut () {
  for ((j=1; j<=$length-6; j++));
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
}

main () {
  #setup variable and array of files 
  setvars

  # use for loop read all filenames
  for (( i=0; i<${tLen}; i++ ));
  do
    clear
    #cut up the filename
    filename="${fileArray[$i]}"
    length=${#filename}
    #remove windows file extension
    displayname=${filename:2:$length-6}
    #store the file extension
    fileext=${filename:$length-4}
    #clear out the display vars
    line1=""
    line2=""
    echo $displayname

    #show the character positions
    displaycut
    #prompt for a cut off point
    getcutoff
    #rename the file
    rename
  done
  #clear

  #Display the results
  echo Updated Directory Results
  echo =========================
  echo 
  ls -lh
}

main