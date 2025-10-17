#!/usr/bin/env bash

set -euo pipefail
# set -x 

export LC_ALL=C.UTF-8

readonly LENGTH=${LENGTH:-30}
readonly SLEEP_ON_START=${SLEEP_ON_START:-0.5}
readonly SLEEP_ON_SCROLL=${SLEEP_ON_SCROLL:-0.15}

readonly PLAY_ICON=${PLAY_ICON:-"▶"}
readonly PAUSE_ICON=${PAUSE_ICON:-"‖"}
readonly NEXT_ICON=${NEXT_ICON:-"»"}
readonly PREV_ICON=${PREV_ICON:-"«"}

cursor_position=0
track_text=''

get_track_name() {
    playerctl metadata --format '{{ artist }} - {{ title }}'
}

get_player_status() {
    playerctl status
}

pad_string() {
    local s="$1"
    local target_len="$2"
    local current_len="${#s}"
    if (( current_len < target_len )); then
        local pad_len=$(( target_len - current_len ))
        printf -v s "%s%*s" "$s" "$pad_len" ""
    fi
    echo "$s"
}

scroll() {
    local text="$1"
    local out_var="$2"
    local text_length=${#text} 
    if (( text_length <= LENGTH )); then
        printf -v "$out_var" "%s" "$(pad_string "$text" $LENGTH)"
        return 0
    fi
    local padding='    '
    local padded="$text$padding"
    local paddedLength=${#padded} 
    local doubled="$padded$padded"   
    local result=${doubled:cursor_position:LENGTH}
    ((cursor_position = cursor_position + 1))
    if (( cursor_position >= paddedLength )); then
        cursor_position=0
    fi
    result=$(pad_string "$result" $LENGTH)
    printf -v "$out_var" "%s" "$result"
}

while :
do
    track_text=$(get_track_name)

    scrolled_text=''
    middle_icon=''
    player_status=$(get_player_status)

    if [[ "$player_status" == "Paused" ]]; then
        middle_icon="%{A:playerctl play:}$PLAY_ICON%{A}"
        cursor_position=0
    else 
        middle_icon="%{A:playerctl pause:}$PAUSE_ICON%{A}"
        if ((cursor_position == 0)); then
            sleep $SLEEP_ON_START
        fi
    fi

    scroll "$track_text" "scrolled_text"

    prev="%{A:playerctl previous:}$PREV_ICON%{A}"
    next="%{A:playerctl next:}$NEXT_ICON%{A}"

    echo "$scrolled_text | $prev $middle_icon $next"

    sleep $SLEEP_ON_SCROLL
done
