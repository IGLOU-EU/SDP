#!/bin/bash

files=""

in_f="${in_f:=nul}"
out_f="${out_f:=nul}"
out_p="${out_p:=nul}"

for file in "$out_f/$out_p"*; do
    if [[ $file == *".html" ]]; then
        files+="<li><a href=\"${file##*/}\">${file##*/}</a></li>"
    fi
done

out="$(cat "$in_f/index.html")"
echo "${out//'[=index]'/${files}}" > "$out_f/index.html"
