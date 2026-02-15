# Unreal Content & Feature Pack Template

This project is a starter template for building a custom Unreal Engine **Content Pack** (`.upack`) that appears in the **Add Feature or Content Pack** dialog.

## What this template contains

- `Samples/MyContentPack/Content/MyContentPack/`  
	Put your Unreal assets here (`.uasset`, `.umap`, etc.).
- `ContentSettings/manifest.json`  
	Metadata shown in the Unreal Editor (name, description, thumbnail, tags).
- `ContentSettings/Config/config.ini`  
	Tells Unreal which files to include from `Samples/...`.
- `ContentSettings/Media/`  
	Preview images referenced by `manifest.json`.
- `ContentToPack.txt`  
	List of files/folders UnrealPak should package.
- `EditPaths_CreatePak.bat.txt`  
	Command template used to run `UnrealPak.exe`.
- `FeaturePacks/`  
	Output folder for the generated `.upack` file.

## Prerequisites

- Unreal Engine installed (same major version you want to support).
- Access to `UnrealPak.exe`, usually at:  
	`C:\Program Files\Epic Games\UE_5.x\Engine\Binaries\Win64\UnrealPak.exe`
- Your content already migrated into this template under:  
	`Samples/MyContentPack/Content/MyContentPack/`

## Step-by-step: Create your content pack

### 1) Add your content

Copy your pack assets into:

`Samples/MyContentPack/Content/MyContentPack/`

Keep folder structure clean. The folder name inside `Content/` becomes the root content folder users see after adding the pack.

### 2) Update pack metadata

Edit `ContentSettings/manifest.json`:

- `Name[].Text` → Display name in Unreal UI
- `Description[].Text` → Short description
- `SearchTags[].Text` → Search keywords
- `Thumbnail` → File name in `ContentSettings/Media/`
- `Screenshots` → File names in `ContentSettings/Media/`

Example media files expected by current template:

- `MyContentpack.png`
- `MyContentpack_Preview.png`

Place those files in `ContentSettings/Media/` (or change names in `manifest.json`).

### 3) Verify included file paths

Check `ContentSettings/Config/config.ini`:

```ini
[AdditionalFilesToAdd]
+Files=Samples/MyContentPack/Content/*.*
```

If you renamed folders, update this path accordingly.

### 4) Set local paths for packing

Edit `ContentToPack.txt` and replace `YOUR_FOLDER_PATH` with your actual local path to this repository.

Current entries:

```txt
"YOUR_FOLDER_PATH\ContentPack\ContentSettings\Config\"
"YOUR_FOLDER_PATH\ContentPack\ContentSettings\Media\"
"YOUR_FOLDER_PATH\ContentPack\ContentSettings\manifest.json"
```

Then edit `EditPaths_CreatePak.bat.txt`:

- Replace `YOUR_ENGINE_PATH` with your Unreal install root.
- Replace `YOUR_FOLDER_PATH` with your local template root.
- Optionally rename output from `MyContentPack.upack`.

Current command template:

```bat
"YOUR_ENGINE_PATH\UE_5.0\Engine\Binaries\Win64\UnrealPak.exe" -Create="YOUR_FOLDER_PATH\ContentPack\ContentToPack.txt" "YOUR_FOLDER_PATH\ContentPack\FeaturePacks\MyContentPack.upack"
@pause
```

### 5) Build the `.upack`

1. Rename `EditPaths_CreatePak.bat.txt` to `CreatePak.bat` (or create a new `.bat` file with the edited command).
2. Double-click the `.bat` file.
3. Confirm output file exists at:

`FeaturePacks/MyContentPack.upack`

## Install the pack into Unreal Engine

Copy the generated `.upack` into your engine FeaturePacks directory, for example:

`C:\Program Files\Epic Games\UE_5.x\FeaturePacks\`

Then in Unreal Editor:

1. Open/create a project.
2. Use **Add** → **Add Feature or Content Pack**.
3. Find your pack by `Name`/thumbnail from `manifest.json`.
4. Add it to the project.

## Optional customization

- Rename `MyContentPack` folder and `.upack` output to your product name.
- Localize `manifest.json` by adding more language entries.
- Add more screenshots in `ContentSettings/Media/` and list them in `Screenshots`.

## Troubleshooting

- Pack does not appear in Unreal:
	- Verify `.upack` is in the correct `FeaturePacks` folder for the engine version you launched.
	- Validate `manifest.json` syntax (valid JSON, no trailing commas).
- Missing preview image:
	- Ensure file names in `manifest.json` exactly match files in `ContentSettings/Media/`.
- UnrealPak command fails:
	- Recheck paths in both `ContentToPack.txt` and `.bat` file.
	- Confirm `UnrealPak.exe` exists at the path you specified.

## Quick checklist

- [ ] Assets copied to `Samples/MyContentPack/Content/MyContentPack/`
- [ ] `manifest.json` updated
- [ ] Media files added to `ContentSettings/Media/`
- [ ] `ContentToPack.txt` paths updated
- [ ] `.bat` command paths updated
- [ ] `.upack` generated in `FeaturePacks/`
- [ ] `.upack` copied to engine `FeaturePacks/`

