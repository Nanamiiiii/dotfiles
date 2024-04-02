# posh-git
Import-Module posh-git

# ghq + fzf
function repo() {
    $root = "$(ghq root)"
    $repo = "$(ghq list | fzf --preview="ls -AF --color=always ${root}/{1}")"
    if (!([string]::IsNullOrEmpty($repo))) {
        Set-Location "${root}/${repo}"
    }
}

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Command Not Found
#34de4b3d-13a8-4540-b76d-b9e8d3851756 PowerToys CommandNotFound module
Import-Module "C:\Program Files\PowerToys\WinUI3Apps\..\WinGetCommandNotFound.psd1"
#34de4b3d-13a8-4540-b76d-b9e8d3851756

# Alias
function __ls() {
    eza --icons --group-directories-first
}
function __ll() {
    eza --group-directories-first -al --header --color-scale --git --icons --time-style=long-iso
}
function __tree() {
    eza --group-directories-first -T --icons
}

Set-Alias -Name ls -Value __ls
Set-Alias -Name ll -Value __ll
Set-Alias -Name tree -Value __tree

# starship
Invoke-Expression (&starship init powershell)
