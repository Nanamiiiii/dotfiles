on run argv
    if argv = {} then return "must specify app name."
    set app_name to argv's item 1
    tell application (app_name) to run
    tell application "System Events"
        if visible of application process (app_name) is true then
            set visible of application process (app_name) to false
        else
            set visible of application process (app_name) to true
        end if
    end tell
end run
