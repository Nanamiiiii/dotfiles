tell application "Finder"
    if frontmost then
        set visible of process "Finder" to false
    else
        if (count windows) is 0 then reveal home
        activate
    end if
end tell

