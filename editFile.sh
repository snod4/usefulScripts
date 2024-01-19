#!/bin/sh
#echo > /home/csnodgrass233/dirTest.txt

findProjectRoot(){
  echo $(findProjectRootCore "$1" "$1")
  return
}

findProjectRootCore(){
  if [[ -z "$1" ]];then
    echo -1
    return
  fi
  if [[ "$1" == "/" ]];then
    homePath=~
    if [[ "$2" =~ ^"$homePath".* ]];then 
      #echo "Failed homepath" >> /home/csnodgrass233/dirTest.txt
      echo $homePath
      return
    else
      echo $(dirname "$2")
      return
    fi
  fi
  #Try to find git files for root project directory
  curDir=$(dirname $1)
  #echo $curDir >> /home/csnodgrass233/dirTest.txt
  if [[ -n $(ls -a "$curDir" | rg "^\.git\$") ]];then
    #echo "Winner\=$curDir" >> /home/csnodgrass233/dirTest.txt
    echo $curDir
    return
  else
    val=$(findProjectRootCore $curDir $2)
    #echo "Val\=$val" >> /home/csnodgrass233/dirTest.txt
    echo $val
    return
  fi


}

inputFile=$(rg --files -uu /home/csnodgrass233 | fzf --preview 'bat {}')
if [[ -z "$inputFile" ]];then 
  hyprctl dispatch closewindow
  exit
fi 
#Finds project root (Assume it has a .git file. Otherwise ~/ is used))
inputDirectory=$(findProjectRoot "$inputFile")
#echo "Gottem"$inputDirectory >> /home/csnodgrass233/dirTest.txt
hyprctl dispatch togglefloating
#Opens nvim to determined directory for a selected file
tmux new-session "nvim $inputFile -c \"cd $inputDirectory\""
