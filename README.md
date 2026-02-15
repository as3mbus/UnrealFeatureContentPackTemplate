# Unreal Content & Feature Pack Template

This project is a starter template for building a custom Unreal Engine **Content Pack** (`.upack`) that appears in the **Add Feature or Content Pack** dialog.

## Quick Action CheckList

1. [ ] fill out `PackageContent` directory (Content / Source)
2. [ ] modify `PackageContent/manifest.json`
3. [ ] (Optional) fill out Samples file and modify `PackageContent/Config/config.ini`
4. [ ] execute CreatePak.bat
5. [ ] copy resulting `.upack` file to `UNREAL_ENGINE_PATH/FeaturePacks` 
   1. [ ] (Optional) also Copy `Samples` folder to `UNREAL_ENGINE_PATH/Samples` 

## What this template contains

- `PackageContent`

  Root Directory for unreal package content
- `PackageContent/Content/`
  
  Put your Unreal assets here (`.uasset`, `.umap`, etc.).
- `PackageContent/Source/`

  Put your Unreal C++ assets here (Module definition and codes)
- `PackageContent/manifest.json`  
  
  Metadata shown in the Unreal Editor (name, description, thumbnail, tags).
- `PackageContent/Config/config.ini`  
  
  Tells Unreal on which file to add based on engine directory
- `PackageContent/Media/`  

  Preview images referenced by `manifest.json`.
- `CreatePak.ps1`

  Packaged Command used to run `UnrealPak.exe`.
- `FeaturePacks/`  
  
  Default Output folder for the generated `.upack` file. (following unreal engine directory format)
- `Samples/MyContentPack/Content/`
  
  Put your general unpacked Unreal assets here (`.uasset`, `.umap`, etc.).

## Prerequisites

- Unreal Engine installed (same major version you want to support).
- Access to `UnrealPak.exe`, usually at:  
	`C:\Program Files\Epic Games\UE_5.x\Engine\Binaries\Win64\UnrealPak.exe`
- Your content already migrated into this template under:  
	`Samples/MyContentPack/Content/`

## Step-by-step: Create your content pack

### 1) Add your content

Copy your pack assets into: `PackageContent/Content`

if you plan to have multiple content pack reusing common asset you can use `Samples` folder to contain general asset to be added when a pack is added into your project

put your assets in `Samples/MyContentPack/Content/`
and update `PackageContent/Config/config.ini` to include the file you plan to add into the package content

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

### 4) Build the `.upack`

1. Execute CreatePak.bat
2. fill out given prompt
   1. Specific Unreal Engine Version Directory Path
   2. resulting UPack files path

## Install the pack into Unreal Engine

Copy the generated `.upack` into your engine FeaturePacks directory, for example:

`C:\Program Files\Epic Games\UE_5.x\FeaturePacks\`

If you are using `Samples` Folder also copy the path to Unreal Engine `Samples` folder directory so it can be included based on config path written

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

