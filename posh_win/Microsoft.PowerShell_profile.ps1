if(-not $env:path.Split(';').Contains('.')){
    $env:path += ";."
}

function Run-AsAdmin() {
    if($args.count -eq 0){
        Start-Process -Verb runas powershell
        return
    }
    Start-Process -Verb runas -ArgumentList @('-command', "$($args -join ' ')") powershell
}

Set-Alias -Name:"sudo" -Value:"Run-AsAdmin" -Description:"Start the certain process as administrator" -Option:"None"

Invoke-Expression (&starship init powershell)

