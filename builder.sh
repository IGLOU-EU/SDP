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
canvas_r="${canvas_r:-15}"
canvas_c="${canvas_c:-15}"

in_css="${in_css:-./resources/draw_.css}"
in_html="${in_html:-./resources/draw_.html}"

out_dir="${out_dir:-./public/}"
out_css="${out_css:-draw_${canvas_c}x${canvas_r}.css}"
out_html="${out_html:-draw_${canvas_c}x${canvas_r}.html}"

in_css="$(cat "${in_css}")"
in_html="$(cat "${in_html}")"

grid_css=""
grid_check=""
grid_cells=""

((cells = canvas_r * canvas_c))

# MAIN
buildGrid "black"
buildGrid "red"
buildGrid "green"
buildGrid "blue"
buildGrid "white"

insertData "in_css" "grid_css"
insertData "in_css" "canvas_r"
insertData "in_css" "canvas_c"
insertData "in_html" "out_css"
insertData "in_html" "grid_check"
insertData "in_html" "grid_cells"

writeoutput "$in_html" "$out_dir$out_html"
writeoutput "$in_css"  "$out_dir$out_css"

quit
