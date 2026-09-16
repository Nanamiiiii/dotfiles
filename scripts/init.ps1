$ErrorActionPreference = 'Stop'

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
        throw "Error: Failed to create symbolic link.`n$_"
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
        if (-not (Test-Path -Path "$pwshdir\Microsoft.PowerShell_profile.ps1" -PathType Leaf)) {
            New-Item -ItemType File -Path "$pwshdir\Microsoft.PowerShell_profile.ps1" -Force | Out-Null
            Write-Host "[Created] File: $pwshdir\Microsoft.PowerShell_profile.ps1" -ForegroundColor Green
        }
        Add-Content -Value '. "$Env:USERPROFILE\dotfiles\config\pwsh\Microsoft.PowerShell_profile.ps1"' -Path "$pwshdir\Microsoft.PowerShell_profile.ps1"

        # .gitconfig
        $gpgpath = (Get-Command gpg).Source
        Copy-Item -Path $gitconfig -Destination "$Env:USERPROFILE\.gitconfig" -Force
        git config --global gpg.program $gpgpath
        git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"

        # wezterm
        New-SymLink -TargetPath $wezterm -LinkPath "$Env:USERPROFILE\.wezterm.lua" -Force
    } catch {
        throw "[Error] Failed to distribute configurations.`n$_"
    }
}

function check_dotdir {
    $dotdir = "$Env:USERPROFILE\dotfiles"
    return [bool](Test-Path -Path $dotdir -PathType Container)
}

function check_winget {
    if (-not (Get-Command winget -CommandType Application -ErrorAction SilentlyContinue)) {
        throw "Install or update App Installer to get WinGet 1.11 or later, then rerun this script."
    }
    $version = winget --version
    if ($LASTEXITCODE -ne 0 -or "$version" -notmatch '^v?(\d+\.\d+\.\d+)') {
        throw "Failed to determine the WinGet version. Update App Installer and rerun this script."
    }
    if ([version]$Matches[1] -lt [version]'1.11.0') {
        throw "WinGet 1.11 or later is required. Update App Installer and rerun this script."
    }
}

function check_git {
    if (-not (Get-Command git -CommandType Application -ErrorAction SilentlyContinue)) {
        winget install --id Git.Git --exact --source winget --accept-source-agreements --accept-package-agreements --disable-interactivity
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install Git via winget (exit code: $LASTEXITCODE)."
        }
        $Env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + $Env:Path
        if (-not (Get-Command git -CommandType Application -ErrorAction SilentlyContinue)) {
            throw "Git was installed but is not on PATH. Open a new PowerShell session and rerun this script."
        }
        Write-Host "[Info] git was successfully installed."
    } else {
        Write-Host "[Info] git has been already installed."
    }
}

function check_mise {
    if (-not (Get-Command mise -CommandType Application -ErrorAction SilentlyContinue)) {
        winget install --id jdx.mise --exact --source winget --accept-source-agreements --accept-package-agreements
        if ($LASTEXITCODE -ne 0) {
            throw "Failed to install mise via winget (exit code: $LASTEXITCODE)."
        }

        # winget updates the persisted PATH, not this PowerShell process.
        $Env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
            [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + $Env:Path
        if (-not (Get-Command mise -CommandType Application -ErrorAction SilentlyContinue)) {
            throw "mise was installed but is not on PATH. Open a new PowerShell session and rerun this script."
        }
        Write-Host "[Info] mise was successfully installed."
    } else {
        Write-Host "[Info] mise has been already installed."
    }
}

function install_winget_packages {
    $source = "$Env:USERPROFILE\dotfiles\scripts\configuration.winget"
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "WinGet configuration not found: $source"
    }
    if (-not (Get-Command winget -CommandType Application -ErrorAction SilentlyContinue)) {
        throw "WinGet is required. Install or update App Installer to get WinGet 1.11 or later, then rerun this script."
    }

    winget configure --file $source --accept-configuration-agreements --disable-interactivity
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to apply WinGet configuration (exit code: $LASTEXITCODE)."
    }

    # Installers update the persisted PATH, not this PowerShell process.
    $Env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
        [Environment]::GetEnvironmentVariable('Path', 'User') + ';' + $Env:Path
    Write-Host "[Info] WinGet configuration was successfully applied."
}

function install_mise_tools {
    $source = "$Env:USERPROFILE\dotfiles\mise\config.toml"
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "mise configuration not found: $source"
    }

    if ($Env:MISE_GLOBAL_CONFIG_FILE -or $Env:MISE_CONFIG_FILE) {
        throw "Unset MISE_GLOBAL_CONFIG_FILE and MISE_CONFIG_FILE before using the default mise configuration link."
    }

    $configDir = if ($Env:MISE_CONFIG_DIR) {
        $Env:MISE_CONFIG_DIR
    } elseif ($Env:XDG_CONFIG_HOME) {
        Join-Path $Env:XDG_CONFIG_HOME 'mise'
    } else {
        "$Env:USERPROFILE\.config\mise"
    }
    $link = Join-Path $configDir 'config.toml'
    New-Item -ItemType Directory -Path $configDir -Force -ErrorAction Stop | Out-Null
    $existing = Get-Item -LiteralPath $link -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -ne 'SymbolicLink' -or $existing.Target -ne $source) {
            throw "Refusing to overwrite $link; back it up first."
        }
    } else {
        New-Item -ItemType SymbolicLink -Path $link -Value $source -ErrorAction Stop | Out-Null
        Write-Host "[Created] Symlink: $link to $source" -ForegroundColor Green
    }

    mise trust $source
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to trust mise configuration (exit code: $LASTEXITCODE)."
    }
    mise install --yes
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install mise tools (exit code: $LASTEXITCODE)."
    }
}

#### Main Script ####
# Run as Administrator
# needed by symlink creation
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $process = Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs -Wait -PassThru
    exit $process.ExitCode
}

check_winget
# Git is needed to prepare the repository before applying its WinGet configuration.
check_git

# prepare dotfiles directory
if (check_dotdir) {
    Write-Host "[Info] dotdir seems to be prepared"
} else {
    # Bootstrap must not depend on preconfigured SSH keys.
    git clone https://github.com/Nanamiiiii/dotfiles.git "$Env:USERPROFILE\dotfiles"
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to clone dotfiles repository (exit code: $LASTEXITCODE)."
    }
    Write-Host "[Info] dotdir was successfully prepared"
}

install_winget_packages
check_mise
install_mise_tools
distribute_config

Pause
