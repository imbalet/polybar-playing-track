#!/usr/bin/env bash

set -euo pipefail
# set -x 

export LC_ALL=C.UTF-8

readonly LENGTH=35
readonly SLEEP_ON_START=0.5
readonly SLEEP_ON_SCROLL=0.15

readonly PLAY_ICON="▶"
readonly PAUSE_ICON="‖"
readonly NEXT_ICON="»"
readonly PREV_ICON="«"

cursorPosition=0
trackText=''

getTrackName() {
    playerctl metadata --format '{{ artist }} - {{ title }}'
}

getPlayerStatus() {
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
    local textLength=${#text} 
    if (( textLength <= LENGTH )); then
        printf -v "$out_var" "%s" "$(pad_string "$text" $LENGTH)"
        return 0
    fi
    local padding='    '
    local padded="$text$padding"
    local paddedLength=${#padded} 
    local doubled="$padded$padded"   
    local result=${doubled:cursorPosition:LENGTH}
    ((cursorPosition = cursorPosition + 1))
    if (( cursorPosition >= paddedLength )); then
        cursorPosition=0
    fi
    result=$(pad_string "$result" $LENGTH)
    printf -v "$out_var" "%s" "$result"
}

while :
do
    trackText=$(getTrackName)

    scrolledText=''
    middleIcon=''
    playerStatus=$(getPlayerStatus)

    if [[ "$playerStatus" == "Paused" ]]; then
        middleIcon="%{A:playerctl play:}$PLAY_ICON%{A}"
        cursorPosition=0
    else 
        middleIcon="%{A:playerctl pause:}$PAUSE_ICON%{A}"
        if ((cursorPosition == 0)); then
            sleep $SLEEP_ON_START
        fi
    fi

    scroll "$trackText" "scrolledText"

    prev="%{A:playerctl previous:}$PREV_ICON%{A}"
    next="%{A:playerctl next:}$NEXT_ICON%{A}"

    echo "$scrolledText $prev $middleIcon $next"

    sleep $SLEEP_ON_SCROLL
done
