# version 1.0.0
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

$root = $PSScriptRoot

$OutputName = "ContentPack"
$EnginePathSaveFile = "./Saved/EngineDirectory.txt"
$pakListFile = Join-Path $root "Saved/PakList.txt"
$content = Join-Path $root "PackageContent"
$featurePacksDir = Join-Path $root "FeaturePacks"
$engineConfigPath = Join-Path $root "EngineDirectory.txt"
$engineDirectory = $null


# check if config path exists, if not create empty file to avoid errors when trying to read it
if(-not (Test-Path $EnginePathSaveFile))
{
    Write-Host "Config file not found, creating new one at: $EnginePathSaveFile" -ForegroundColor Yellow
    #Create the directory if it doesn't exist
    $configDir = Split-Path $EnginePathSaveFile -Parent
    if(-not (Test-Path $configDir))
    {
        New-Item -Path $configDir -ItemType Directory | Out-Null
    }
    New-Item -Path $EnginePathSaveFile -ItemType File | Out-Null
}
# Load file in Config Path if exist
$engineDirectory = Get-Content -Path $EnginePathSaveFile

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
$engineFeaturesDir = Join-Path $engineDirectory "FeaturePacks"
$engineSamplesDir = Join-Path $engineDirectory "Samples"
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
    $outputPath = $outputDialog.FileName
}
else
{
    Write-Host "Output file selection cancelled, exiting." -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# generate list of files to include in upack file by iterating over content folder and adding all files and folders in it to the list, then save the list to a temporary file to be used as input for UnrealPak.exe

# iterate over folder and file only in top directory and create list of files to include in upack
$pakList = @()
Get-ChildItem -Path $content -recurse | ForEach-Object {
    if($_.PSIsContainer)
    {
        $pakList += "$($_.FullName)\"
    }
}
Get-ChildItem -Path $content | ForEach-Object {
    # add \ if it's a directory to include all files in it
    if(-not $_.PSIsContainer)
    {
        $pakList += "$($_.FullName)"
    }
}
#adjust upack list order to have deeper directories first to avoid issues with UnrealPak when there are files with same name in different directories
$pakList = $pakList | Sort-Object -Descending

# create temporary file with list of files to include in upack
$pakList | Out-File -FilePath $pakListFile -Encoding UTF8

# Build the upack file using UnrealPak.exe
Write-Host "Building pak file..." -ForegroundColor Cyan
Write-Host "Engine Directory : $engineDirectory"
Write-Host "$UnrealPakPath -create=$pakListFile $outputPath"

Push-Location $root
& $UnrealPakPath -create="$pakListFile" "$outputPath"
$err = $LASTEXITCODE
Pop-Location


Write-Host ""
if ($err -ne 0) {
    Write-Host "Build failed with error $err" -ForegroundColor Red
}
else {
    Write-Host "Build succeeded: $outputPath" -ForegroundColor Green
}

if($save)
{
    $engineDirectory | Out-File -FilePath $EnginePathSaveFile
}

# Copy the generated upack file to the FeaturePacks directory overwriting any existing file with the same name
$destinationPath = Join-Path $engineFeaturesDir (Split-Path $outputPath -Leaf)
Copy-Item -Path $outputPath -Destination $destinationPath -Force
Write-Host "Copied upack file to: $destinationPath" -ForegroundColor Green

# copy Samples folder content to Engine Samples folder if it exists, creating it if it doesn't exist don't overwrite existing files to avoid issues with existing samples in engine, only copy new files from the Samples folder in the project
if(Test-Path $engineSamplesDir)
{
    Write-Host "Copying sample files to engine samples directory: $engineSamplesDir" -ForegroundColor Green
    Get-ChildItem -Path (Join-Path $root "Samples") -Recurse | ForEach-Object {
        $destination = Join-Path $engineSamplesDir $_.FullName.Substring($root.Length).TrimStart('\')
        if($_.PSIsContainer)
        {
            if(-not (Test-Path $destination))
            {
                New-Item -Path $destination -ItemType Directory | Out-Null
            }
        }
        else
        {
            if(-not (Test-Path $destination))
            {
                Copy-Item -Path $_.FullName -Destination $destination -Force
            }
        }
    }
}
else
{
    Write-Host "Engine samples directory not found, skipping copying sample files: $engineSamplesDir" -ForegroundColor Yellow
}

Read-Host -Prompt "Press Enter to exit"
exit $err
