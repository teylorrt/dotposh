
$global:installFilesFolder = "$HOME\dot-posh-install"
$dotPoshFolder = "$HOME\dotfiles\dot-posh"
$baseUri = "https://raw.githubusercontent.com/teylorrt/dotposh/refs/heads/main"

function ensureFolder {
    param (
        [Parameter(Mandatory=$true)]
        [string]$folder
    )

    if (!(Get-Item $folder -errorAction SilentlyContinue)) {
        New-Item -ItemType Directory -Path $folder -Force
    }

    Write-Host "Folder $folder created successfully."
}

function downloadFile {
    param (
        [Parameter(Mandatory=$true)]
        [string]$uri,
        [Parameter(Mandatory=$true)]
        [string]$destinationFolder
    )
    
    Invoke-WebRequest -Uri $uri -OutFile $destinationFolder -UseBasicParsing
    Write-Host "Downloaded $uri"
}

function downloadFiles {
    param (
        [Parameter(Mandatory=$true)]
        [string]$path,
        [Parameter(Mandatory=$true)]
        [string[]]$files,
        [Parameter(Mandatory=$true)]
        [string]$destinationFolder
    )

    Write-Host "Downloading $path files..."
    foreach ($fileName in $files) {
        $uri = "$baseUri/$path/$fileName"
        downloadFile $uri $destinationFolder
    }
}

[string[]]$foldersToEnsure = @(
    $dotPoshFolder, 
    $installFilesFolder
)


### ensure folders
foreach ($folder in $foldersToEnsure) {
    ensureFolder $folder
}

### Download install files ###
[string[]]$installFiles = @(
    "install-font.ps1", 
    "terminal-settings.ps1",
    "utils.ps1",
    "dot-posh.omp.json",
    "configure-terminal-settings.ps1"
)
downloadFiles "install" $installFiles $installFilesFolder

### Download dot-posh files ###
[string[]]$dotPoshFiles = @(
    "aliases.ps1", 
    "commands.ps1", 
    "environment.ps1",
    "git-config.ps1"
)
downloadFiles "dot-posh" $dotPoshFiles $dotPoshFolder

### configure terminal settings
. "$installFilesFolder\configure-terminal-settings.ps1"

### remove install files
Write-Host "Removing install files..."
Remove-Item -Path $installFilesFolder -Recurse -Force


### Set initialization of Dot-Posh in profile
'' | Out-File -Append -Encoding default -FilePath $profile
'# load Dot-Posh' | Out-File -Append -Encoding default -FilePath $profile
'. "$HOME\dot-posh.ps1"' | Out-File -Append -Encoding default -FilePath $profile

### reload profile
. $PROFILE
