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

function distribute_config {
    $dotdir = "$Env:USERPROFILE\dotfiles"
    $pwshdir = "$Env:USERPROFILE\Documents\PowerShell"
    $pwsh_profile = "$dotdir\config\pwsh\Microsoft.PowerShell_profile.ps1"
    $gitconfig = "$dotdir\config\git\config"
    $wezterm = "$dotdir\config\wezterm\wezterm.lua"

    try {
        # PowerShell Profile
        if (-not (Test-Path -Path $pwshdir -PathType Container)) {
            New-Item -ItemType Directory -Path $pwshdir -Force | Out-Null
            Write-Host "[Created] Directory: $pwshdir" -ForegroundColor Green
        }
        New-SymLink -TargetPath $pwsh_profile -LinkPath "$pwshdir\persistent_profile.ps1" -Force
        if (-not (Test-Path -Path "$pwshdir\Microsoft.PowerShell_profile.ps1" -PathType Leaf)) {
            New-Item -ItemType File -Path "$pwshdir\Microsoft.PowerShell_profile.ps1" -Force | Out-Null
            Write-Host "[Created] File: $pwshdir\Microsoft.PowerShell_profile.ps1" -ForegroundColor Green
        }
        Add-Content -Value ". $pwshdir\persistent_profile.ps1" -Path "$pwshdir\Microsoft.PowerShell_profile.ps1"

        # .gitconfig
        $gpgpath = (Get-Command gpg).Source
        Copy-Item -Path $gitconfig -Destination "$Env:USERPROFILE\.gitconfig" -Force
        git config --global gpg.program $gpgpath
        git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"

        # wezterm
        New-SymLink -TargetPath $wezterm -LinkPath "$Env:USERPROFILE\.wezterm.lua" -Force
    } catch {
        Write-Error "[Error] Failed to distribute configurations.`n$_" -ForegroundColor Red
    }
}

function check_dotdir {
    $dotdir = "$Env:USERPROFILE\dotfiles"
    return [bool](Test-Path -Path $dotdir -PathType Container)
}

function check_git {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        try {
            winget install Git.Git
            Write-Host "[Info] git was successfully installed."
        } catch {
            Write-Error "[Error] Failed to install via winget: git" -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "[Info] git has been already installed."
    }
}

function check_aqua {
    if (-not (Get-Command aqua -ErrorAction SilentlyContinue)) {
        try {
            winget install aquaproj.aqua
            Write-Host "[Info] aqua was successfully installed."
        } catch {
            Write-Error "[Error] Failed to install via winget: aqua" -ForegroundColor Red
            exit
        }
    } else {
        Write-Host "[Info] aqua has been already installed."
    }
}

#### Main Script ####
# Run as Administrator
# needed by symlink creation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# confirm aqua is installed
check_aqua
# confirm git is installed
check_git

# prepare dotfiles directory
if (check_dotdir) {
    Write-Host "[Info] dotdir seems to be prepared"
} else {
    try {
        if (Get-Command gpg -ErrorAction SilentlyContinue) {
            git clone git@github.com:Nanamiiiii/dotfiles.git "$Env:USERPROFILE\dotfiles"
        } else {
            git clone https://github.com/Nanamiiiii/dotfiles.git "$Env:USERPROFILE\dotfiles"
        }
    } catch {
        Write-Error "[Error] Failed to clone dotfiles repository." -ForegroundColor Red
        exit
    }
    Write-Host "[Info] dotdir was successfully prepared"
}

distribute_config
