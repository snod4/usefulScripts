#!/bin/sh
#
#Take STD out and echo it back out after analyzing it? how?
git difftool $@
echo $cmdLineInfo
status=$?
  if [[ $status == 0 ]];then 
    echo "Files are equivalent"
  else 
    echo "There was an error with the diff tool: $status"
  fi


