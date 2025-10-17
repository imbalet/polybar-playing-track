#!/usr/bin/env bash

set -euo pipefail
# set -x 

export LC_ALL=C.UTF-8

readonly OUTPUT_FORMAT=${OUTPUT_FORMAT:-'%track_metadata% | %prev_icon% %middle_icon% %next_icon% | %padding%'}

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
    playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null || echo "No players found"
}

get_player_status() {
    playerctl status 2>/dev/null || echo "No players found"
}

get_padding() {
    local string="$1"
    local target_len="$2"
    local pad_len=$(( target_len - ${#string} ))
    (( pad_len < 0 )) && pad_len=0
    printf '%*s' "$pad_len" ''
}

scroll() {
    local text="$1"
    local out_var="$2"
    local text_length=${#text} 
    if (( text_length <= LENGTH )); then
        printf -v "$out_var" "%s" "$text"
        return 0
    fi
    local padding='    '
    local padded="$text$padding"
    local result="${padded}${padded}"
    result="${result:cursor_position:LENGTH}"
    cursor_position=$(( (cursor_position + 1) % ${#padded} ))
    printf -v "$out_var" "%s" "$result"
}



print_output() {
    local output="$OUTPUT_FORMAT"
    output="${output//%track_metadata%/$scrolled_text}"
    output="${output//%prev_icon%/$prev}"
    output="${output//%middle_icon%/$middle_icon}"
    output="${output//%next_icon%/$next}"
    output="${output//%padding%/$padding}"
    echo "$output"
}

while :
do
    track_text=$(get_track_name) 

    if [[ "$track_text" == 'No players found' ]]; then
        echo ' '
        sleep $SLEEP_ON_SCROLL
        continue
    fi
    scrolled_text=''
    middle_icon=''
    player_status=$(get_player_status)

    if [[ "$player_status" == "Paused" ]]; then
        middle_icon="%{A:playerctl play:}$PLAY_ICON%{A}"
        cursor_position=0
    else 
        middle_icon="%{A:playerctl pause:}$PAUSE_ICON%{A}"
        if ((cursor_position == 1)); then
            sleep $SLEEP_ON_START
        fi
    fi
    scroll "$track_text" "scrolled_text"
    padding=$(get_padding "$scrolled_text" $LENGTH)

    prev="%{A:playerctl previous:}$PREV_ICON%{A}"
    next="%{A:playerctl next:}$NEXT_ICON%{A}"

    print_output

    sleep $SLEEP_ON_SCROLL


done
