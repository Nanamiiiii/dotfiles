#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Please specify capture type."
    echo "Available types:"
    echo "  all window rect clip_all clip_window clip_rect"
    exit 1
fi

TYPE="$1"

if [ "$TYPE" == "all" ]; then
    FILE_NAME="Screenshot_$(date +%Y%m%d%H%M%S).png"
    FILE_PATH="${HOME}/Pictures/ScreenShots/${FILE_NAME}"
    maim "$FILE_PATH" 
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to save screenshot!" "$FILE_NAME"
        exit
    fi
    ACT=$(notify-send -a "Screen Capture" -u normal -A "open=Open" -A "rm=Delete" -A "db=Upload to Dropbox" -w -t 5000 "Screenshot was saved!" "$FILE_NAME")
    if [ "$ACT" == "open" ]; then
        xdg-open "$FILE_PATH"
    elif [ "$ACT" == "rm" ]; then
        rm -f "$FILE_PATH"
        notify-send -a "Screen Capture" -u normal "Screenshot was deleted!" "$FILE_NAME"
    elif [ "$ACT" == "db" ]; then
        cp "$FILE_PATH" "${HOME}/Dropbox/Capture/${FILE_NAME}"
        notify-send -a "Screen Capture" -u normal "Uploaded to Dropbox" "$FILE_NAME"
    fi
elif [ "$TYPE" == "window" ]; then
    WINDOW_ID=$(xdotool getactivewindow)
    WINDOW_CLASS=$(xdotool getwindowclassname "$WINDOW_ID")
    FILE_NAME="${WINDOW_CLASS}_$(date +%Y%m%d%H%M%S).png"
    FILE_PATH="${HOME}/Pictures/ScreenShots/${FILE_NAME}"
    maim --window "$WINDOW_ID" "$FILE_PATH" 
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to save screenshot!" "$FILE_NAME"
        exit
    fi
    ACT=$(notify-send -a "Screen Capture" -u normal -A "open=Open" -A "rm=Delete" -A "db=Upload to Dropbox" -w -t 5000 "Screenshot was saved!" "$FILE_NAME")
    if [ "$ACT" == "open" ]; then
        xdg-open "$FILE_PATH"
    elif [ "$ACT" == "rm" ]; then
        rm -f "$FILE_PATH"
        notify-send -a "Screen Capture" -u normal "Screenshot was deleted!" "$FILE_NAME"
    elif [ "$ACT" == "db" ]; then
        cp "$FILE_PATH" "${HOME}/Dropbox/Capture/${FILE_NAME}"
        notify-send -a "Screen Capture" -u normal "Uploaded to Dropbox" "$FILE_NAME"
    fi
elif [ "$TYPE" == "rect" ]; then
    FILE_NAME="Screenshot_$(date +%Y%m%d%H%M%S).png"
    FILE_PATH="${HOME}/Pictures/ScreenShots/${FILE_NAME}"
    maim --select "$FILE_PATH" 
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to save screenshot!" "$FILE_PATH"
        exit
    fi
    ACT=$(notify-send -a "Screen Capture" -u normal -A "open=Open" -A "rm=Delete" -A "db=Upload to Dropbox" -w -t 5000 "Screenshot was saved!" "$FILE_PATH")
    if [ "$ACT" == "open" ]; then
        xdg-open "$FILE_PATH"
    elif [ "$ACT" == "rm" ]; then
        rm -f "$FILE_PATH"
        notify-send -a "Screen Capture" -u normal "Screenshot was deleted!" "$FILE_NAME"
    elif [ "$ACT" == "db" ]; then
        cp "$FILE_PATH" "${HOME}/Dropbox/Capture/${FILE_NAME}"
        notify-send -a "Screen Capture" -u normal "Uploaded to Dropbox" "$FILE_NAME"
    fi
elif [ "$TYPE" == "clip_all" ]; then
    maim | xclip -selection clipboard -t image/png
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to take screenshot!" "$FILE_PATH"
        exit
    fi
    notify-send -a "Screen Capture" -u normal "Copied to clipboard!"
elif [ "$TYPE" == "clip_window" ]; then
    WINDOW_ID=$(xdotool getactivewindow)
    maim --window "$WINDOW_ID" | xclip -selection clipboard -t image/png
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to take screenshot!" "$FILE_PATH"
        exit
    fi
    notify-send -a "Screen Capture" -u normal "Copied to clipboard!"
elif [ "$TYPE" == "clip_rect" ]; then
    maim --select | xclip -selection clipboard -t image/png
    if [ "$?" -ne 0 ]; then
        notify-send -a "Screen Capture" -u critical "Failed to take screenshot!" "$FILE_PATH"
        exit
    fi
    notify-send -a "Screen Capture" -u normal "Copied to clipboard!"
else
    echo "Invalid capture type: ${TYPE}"
    exit 1
fi

