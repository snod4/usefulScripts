#!/usr/bin/env bash

tmp_dir="/tmp/cliphist"
rm -rf "$tmp_dir"
#Once an entry is selected, it gets passed back in to actually copy to the clipboard
#if [[ -n "$1" ]]; then
#  cliphist decode <<<"$1" | wl-copy 
#  exit 1
#fi

mkdir -p "$tmp_dir"

read -r -d '' prog <<EOF
/^[0-9]+\s<meta http-equiv=/ { next }
match(\$0, /^([0-9]+)\s(\[\[\s)?binary.*(jpg|jpeg|png|bmp)/, grp) {
    system("echo " grp[1] "\\\\\t | cliphist decode >$tmp_dir/"grp[1]"."grp[3])
    print \$0"\0icon\x1f$tmp_dir/"grp[1]"."grp[3]
    next
}
1
EOF

output=$(cliphist list | gawk "$prog" | rofi -dmenu)
if [[ "$?" -ne 0 ]];then
  exit
fi
echo "Got here"
wl-copy "$(cliphist decode <<< $output)" 

termKeyCombo="wtype -M ctrl -M shift -P v -m ctrl -m shift"
generalKeyCombo="wtype -M ctrl -P v -m ctrl"
resultKeyCombo=$termKeyCombo
result=$(hyprctl activewindow | grep $TERMINAL)
if [[ ${#result} -eq 0 ]];then 
  resultKeyCombo=$generalKeyCombo
fi

exec $resultKeyCombo
