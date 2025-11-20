# aqua
Set-Item Env:Path "$Env:LOCALAPPDATA\aquaproj-aqua\bin;$Env:Path"
$Env:AQUA_GLOBAL_CONFIG="$Env:USERPROFILE\dotfiles\aqua\aqua.yaml"
$Env:AQUA_LOG_LEVEL="fatal"
$Env:AQUA_PROGRESS_BAR="true"

# Override SSH Agent Socket
# To avoid overriding of wezterm
$Env:SSH_AUTH_SOCK="\\.\pipe\openssh-ssh-agent"

# Starship
$Env:STARSHIP_CONFIG="$Env:USERPROFILE\dotfiles\config\starship\starship.toml"

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
    eza --icons --group-directories-first $args
}
function __ll() {
    eza --group-directories-first -alg --header --color-scale --git --icons --time-style=long-iso $args
}
function __tree() {
    eza --group-directories-first -T --icons $args
}

Set-Alias -Name ls -Value __ls
Set-Alias -Name ll -Value __ll
Set-Alias -Name tree -Value __tree

# Create Symlink
function New-SymLink {
    <#
    .SYNOPSIS
        Creates a symbolic link.
    .DESCRIPTION
        Creates a symbolic link at the specified path that points to the target file or directory.
        Note: This command may require Administrator privileges or Developer Mode enabled on Windows.
    .PARAMETER TargetPath
        The path to the actual file or directory (the target).
    .PARAMETER LinkPath
        The path (name) where the symbolic link will be created.
    .PARAMETER Force
        Forces the creation, overwriting the file if it already exists.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$TargetPath,

        [Parameter(Mandatory=$true, Position=1)]
        [string]$LinkPath,

        [switch]$Force
    )

    try {
        # Create the symbolic link using New-Item
        # -Value is the target, -Path is the link name
        New-Item -ItemType SymbolicLink -Path $LinkPath -Value $TargetPath -Force:$Force -ErrorAction Stop | Out-Null
        Write-Host "[Created] Symlink: $LinkPath to $TargetPath" -ForegroundColor Green
    } catch {
        Write-Error "Error: Failed to create symbolic link.`n$_" -ForegroundColor Red
    }
}

# starship
Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
#$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#  Import-Module "$ChocolateyProfile"
#}
