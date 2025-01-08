# aqua
Set-Item Env:Path "$Env:LOCALAPPDATA\aquaproj-aqua\bin;$Env:Path"
$Env:AQUA_GLOBAL_CONFIG="C:\Users\Myuu\dotfiles\aqua\aqua.yaml"
$Env:AQUA_LOG_LEVEL="fatal"
$Env:AQUA_PROGRESS_BAR="true"

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

# Alias
function __ls() {
    eza --icons --group-directories-first
}
function __ll() {
    eza --group-directories-first -alg --header --color-scale --git --icons --time-style=long-iso
}
function __tree() {
    eza --group-directories-first -T --icons
}

Set-Alias -Name ls -Value __ls
Set-Alias -Name ll -Value __ll
Set-Alias -Name tree -Value __tree

# starship
Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
