#!/bin/bash
# Copyright 2020 Iglou.eu
# Copyright 2020 Adrien Kara
# license that can be found in the LICENSE file.
shopt -s extglob

# SIG TRAP
trap "quit" 2 3

# FUNCTION
err()
{
    echo "($(date --rfc-3339="seconds")) FATAL ERROR: ${1}"
    exit 1
}

msg()
{
    echo "($(date --rfc-3339="seconds")) ${1}"
}

quit()
{
    msg "Program Termination"
    exit 0
}

initBuilder()
{
    [[ $canvas_r -gt 0 ]] || err "Rows canot be lower or equal 0"
    [[ $canvas_c -gt 0 ]] || err "Columns canot be lower or equal 0"

    [[ -r $in_css ]]   || err "Cant't find '$in_css' file"
    [[ -r $in_html ]]  || err "Cant't find '$in_html' file"
    [[ -w $out_dir ]]  || err "Folder '$out_dir' not writable for '${USER:-...}'"
}

buildGrid()
{
    local _gcss
    local _grid
    local _cbox
    local _color="${1}"

    for id in $(seq "$cells")
    do
        _gcss+="#cell-${_color}-${id}[type=\"checkbox\"]:checked ~ #grid-cells #color-${_color} #celldraw-${_color}-${id}, "
        _cbox+="<input name=\"grid ${_color}\" id=\"cell-${_color}-${id}\" type=\"checkbox\" hidden>"
        _grid+="<label for=\"cell-${_color}-${id}\" id=\"celldraw-${_color}-${id}\" class=\"cell\"></label>"
    done

    grid_css+="${_gcss::-2} {opacity: 100%} "
    grid_check+="${_cbox}"
    grid_cells+="<div id=\"color-${_color}\" class=\"cells\">${_grid}</div>"

    msg "Grid '${_color}' build"
}

insertData()
{
    local _var="${1}"
    local _patern="${2}"

    eval "${_var}='${!_var//'[='${_patern}']'/${!_patern}}'"
    msg "Insert '${_patern}' to '${_var}'"
}

writeoutput()
{
    local _data="${1}"
    local _fout="${2}"

    echo "$_data" > "$_fout" || err "Fail to write '${_fout}'"
    msg "Write '${_fout}' done"
}

# VAR
cells=""
in_css=""
in_html=""
grid_css=""
grid_check=""
grid_cells=""
draw_title=""

canvas_r="${canvas_r:-15}"
canvas_c="${canvas_c:-15}"

in_css="${in_css:-./resources/draw_.css}"
in_html="${in_html:-./resources/draw_.html}"

out_dir="${out_dir:-./public/}"
out_css="${out_css:-draw_${canvas_c}x${canvas_r}.css}"
out_html="${out_html:-draw_${canvas_c}x${canvas_r}.html}"

# MAIN
initBuilder

in_css="$(cat "${in_css}")"
in_html="$(cat "${in_html}")"
draw_title="[SDP] Drawing canvas ${canvas_c}x${canvas_r}"
((cells = canvas_r * canvas_c))

buildGrid "black"
buildGrid "green"
buildGrid "red"
buildGrid "blue"
buildGrid "white"
buildGrid "transparent"

insertData "in_css" "grid_css"
insertData "in_css" "canvas_r"
insertData "in_css" "canvas_c"
insertData "in_html" "out_css"
insertData "in_html" "grid_check"
insertData "in_html" "grid_cells"
insertData "in_html" "draw_title"

writeoutput "$in_html" "$out_dir$out_html"
writeoutput "$in_css"  "$out_dir$out_css"

quit
