param(
    [bool]$reset=1,
    [bool]$save=1
)

Function Get-Folder($initialDirectory="")
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms")|Out-Null

    $foldername = New-Object System.Windows.Forms.FolderBrowserDialog
    $foldername.Description = "Select Unreal Engine Directory (e.g. C:/EpicGames/UE_5.2)"
    $foldername.rootfolder = "MyComputer"
    $foldername.SelectedPath = $initialDirectory

    if($foldername.ShowDialog() -eq "OK")
    {
        $folder += $foldername.SelectedPath
    }

    return $folder
}

$OutputName = "ContentPack.pak"
$root = $PSScriptRoot
$ConfigPath = "./EngineDirectory.txt"
$content = Join-Path $root "PackageContent"
$featurePacksDir = Join-Path $root "FeaturePacks"
$engineConfigPath = Join-Path $root "EngineDirectory.txt"
$engineDirectory = $null


# check if config path exists, if not create empty file to avoid errors when trying to read it
if(-not (Test-Path $ConfigPath))
{
    Write-Host "Config file not found, creating new one at: $ConfigPath" -ForegroundColor Yellow
    New-Item -Path $ConfigPath -ItemType File | Out-Null
}
# Load file in Config Path if exist
$engineDirectory = Get-Content -Path $ConfigPath

# if engine path is not valid clear engine directory variable to trigger folder selection
if($null -ne $engineDirectory -and $engineDirectory -ne "" -and -not (Test-Path $engineDirectory))
{
    Write-Host "WARNING: Unreal Engine directory not found: $engineDirectory" -ForegroundColor Yellow
    $engineDirectory = $null
}

# If engine directory is not set or reset flag is true, prompt user to select it
if($null -eq $engineDirectory -or $engineDirectory -eq "" -or $reset)
{
    $engineDirectory = Get-Folder($engineDirectory)
}

# Final validation of engine directory
if($null -eq $engineDirectory -or $engineDirectory -eq "" -or -not (Test-Path $engineDirectory))
{
    Write-Host "ERROR: Unreal Engine directory not found: $engineDirectory" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Validate UnrealPak.exe path
$UnrealPakPath = Join-Path $engineDirectory "Engine\Binaries\Win64\UnrealPak.exe"
if (-not (Test-Path $UnrealPakPath)) {
    Write-Host "ERROR: UnrealPak.exe not found: $UnrealPakPath" -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# prompt user for Output name and location
$outputDialog = New-Object System.Windows.Forms.SaveFileDialog
$outputDialog.Title = "Select output location for upack file"
$outputDialog.Filter = "Pak files (*.upack)|*.upack|All files (*.*)|*.*"
$outputDialog.InitialDirectory = $featurePacksDir
$outputDialog.FileName = $OutputName

if($outputDialog.ShowDialog() -eq "OK")
{
    $output = $outputDialog.FileName
}
else
{
    Write-Host "Output file selection cancelled, exiting." -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}


# Build the pak file using UnrealPak.exe
Push-Location $root
& $UnrealPakPath -create $output "$content\"
$err = $LASTEXITCODE
Pop-Location


Write-Host ""
if ($err -ne 0) {
    Write-Host "Build failed with error $err" -ForegroundColor Red
}
else {
    Write-Host "Build succeeded: $output" -ForegroundColor Green
}

if($save)
{
    $engineDirectory | Out-File -FilePath $ConfigPath
}

Read-Host -Prompt "Press Enter to exit"
exit $err
