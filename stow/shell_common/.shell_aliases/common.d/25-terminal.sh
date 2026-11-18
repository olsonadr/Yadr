# Terminal output helpers (pipe-able)
# Display last N lines of input like tail, but cleaning the screen before every update.
# Example: date; for i in $(seq 1 2000); do echo $i; sleep 0.03; done | ntail 10
function ntail {
    # ignore anything old
    TAIL_BUFFER=""
    # default to 10 lines of tail output
    NUM_LINES=$((${1:-10} + 1))
    # gets the current time in milliseconds
    function mstime() {
        date +%s%3N
    }
    # prints the current buffer
    function print_buffer() {
        # reduce buffer size to last NUM_LINES lines
        TAIL_BUFFER=$(echo "$TAIL_BUFFER" | tail -n "$NUM_LINES")$'\n'
        # clear the last SCREEN_BUFFER_SIZE lines, preserving the stdout above that
        for _ in $(seq 1 "$SCREEN_BUFFER_SIZE"); do printf "\033[1A\033[2K"; done
        # print the new buffer
        printf "%s" "$TAIL_BUFFER"
        SCREEN_BUFFER_SIZE=$(echo "$TAIL_BUFFER" | wc -l)
        SCREEN_BUFFER_SIZE=$((SCREEN_BUFFER_SIZE - 1))
        LAST_UPDATE=$(mstime)
        NEEDS_REFRESH=false
    }
    LAST_UPDATE=$(mstime) # last time the screen was updated
    NEEDS_REFRESH=false   # whether to refresh the screen
    SCREEN_BUFFER_SIZE=0  # number of lines on the screen
    while IFS= read -r NEW_LINE; do
        # truncate new line to columns
        ((${#NEW_LINE} >= COLUMNS)) && NEW_LINE="${NEW_LINE:0:$COLUMNS}"
        # concatenate new the new line to the buffer
        TAIL_BUFFER="$TAIL_BUFFER$NEW_LINE"$'\n'
        # if last update is greater than 100ms, refresh screen
        if [ $(($(mstime) - LAST_UPDATE)) -gt 100 ]; then
            NEEDS_REFRESH=true
        fi
        # refresh screen if needed
        if [ "$NEEDS_REFRESH" = true ]; then print_buffer; fi
    done </dev/stdin
    # one last refresh for anything leftover
    print_buffer
}

# One-line command (pipe into this for nice output)
function oneline() {
    shopt -s checkwinsize # ensure that COLUMNS is available w/ window size
    local ws
    while IFS= read -r line; do
        if ((${#line} >= COLUMNS)); then
            # Moving cursor back to the front of the line so user input doesn't force wrapping
            printf '\r%s\r' "${line:0:$COLUMNS}"
        else
            ws=$((COLUMNS - ${#line}))
            # by writing each line twice, we move the cursor back to position
            # thus: LF, content, whitespace, LF, content
            printf '\r%s%*s\r%s' "$line" "$ws" " " "$line"
        fi
    done
    echo
}

# Silent background process (job that doesnt give output, or DONE message)
function silent_background() {
    #[[ $- =~ m ]] && oldstate="-m" || oldstate="+m"
    #set -m
    #exec 3>&2 2>/dev/null
    { 2>&3 2>/dev/null "$@" & } 3>&2 2>-
    disown &>/dev/null # Close STD{OUT,ERR} for silence if job has already completed
    #set "${oldstate}"
}

