#!/bin/bash

get_curr_workspace_num() {
    swaymsg -t get_workspaces | jq '.[] | select (.focused==true).num'
}

rofi_input() {
    rofi -dmenu < /dev/null
}

get_opts() {
    echo "= RENAME ="
    echo "= MOVE ="
}

get_workspaces() {
    swaymsg -t get_workspaces |\
    jq -r ".[].name"
}

get_menu() {
    get_opts
    get_workspaces
}

selection="$(get_menu | rofi -dmenu -p '>' -selected-row 2)"

case $selection in

"= RENAME =")
    ws_num="$(get_curr_workspace_num)"
    if [[ $ws_num -eq "-1" ]]; then
        newws="$(rofi -dmenu < /dev/null)"
    else
        newws="$(rofi -dmenu -filter "$ws_num: " < /dev/null)"
    fi
    swaymsg -t command rename workspace to "\"$newws\""
    # Double quoted because the i3 json lexer wants quotes, and the shell wants them.
    ;;
"= MOVE =")
    selection="$(get_workspaces | rofi -dmenu -p '>')"
    swaymsg -t command move container to workspace \""$selection""\""
    ;;
*)
    swaymsg workspace "$selection"
esac
