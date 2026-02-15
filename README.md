# Unreal Content & Feature Pack Template

This project is a starter template for building a custom Unreal Engine Content Pack (`.upack`) that appears in the Add Feature or Content Pack dialog.

## Quick Action Checklist

1. [ ] Put assets in `PackageContent/Content` (and optional C++ in `PackageContent/Source`)
2. [ ] Update `PackageContent/manifest.json`
3. [ ] (Optional) Update `PackageContent/Config/config.ini` and `Samples/`
4. [ ] Run `CreatePak.ps1` (or `CreatePak.bat`)
5. [ ] Copy generated `.upack` to `UNREAL_ENGINE_PATH/FeaturePacks`
6. [ ] (Optional) Copy `Samples/` to `UNREAL_ENGINE_PATH/Samples`

## Project Structure

- `PackageContent/`
  - Root directory for pack metadata and packaged content.
- `PackageContent/Content/`
  - Put your Unreal assets here (`.uasset`, `.umap`, etc.).
- `PackageContent/Source/`
  - Optional Unreal C++ source files.
- `PackageContent/manifest.json`
  - Metadata shown in Unreal Editor (name, description, tags, preview images).
- `PackageContent/Config/config.ini`
  - config modification usually used for additional files from samples folder or input binding
- `PackageContent/Media/`
  - Images referenced by `manifest.json` (`Thumbnail`, `Screenshots`).
- `CreatePak.ps1`
  - PowerShell script that runs `UnrealPak.exe` and builds the `.upack`.
- `CreatePak.bat`
  - Batch wrapper to run pack creation flow.
- `FeaturePacks/`
  - Default Output folder for generated `.upack` files.
- `Samples/MyContentPack/Content/`
  - Optional shared/sample assets for config-driven inclusion.

## Prerequisites

- Unreal Engine installed (target engine version).
- Access to `UnrealPak.exe`, usually:
  - `C:\Program Files\Epic Games\UE_5.x\Engine\Binaries\Win64\UnrealPak.exe`

## Build Steps

1. Add content to `PackageContent/Content`.
2. Update metadata in `PackageContent/manifest.json`.
3. If using shared assets, update `PackageContent/Config/config.ini` paths and place assets in `Samples/...`.
4. Run:
   - `CreatePak.ps1`, or
   - `CreatePak.bat`
5. Confirm output file exists in `FeaturePacks/`.

## Install Into Unreal Engine

1. Copy generated `.upack` into your engine `FeaturePacks` folder:
   - `C:\Program Files\Epic Games\UE_5.x\FeaturePacks\`
2. If used, also copy your `Samples` content into engine `Samples` folder.
3. In Unreal Editor: Add → Add Feature or Content Pack.

## `manifest.json` Property Reference

Current template file: `PackageContent/manifest.json`

```json
{
  "Version": 1,
  "Name": [{ "Language": "en", "Text": "MyContentPack" }],
  "Description": [{ "Language": "en", "Text": "Content for Tutorial" }],
  "AssetTypes": [],
  "SearchTags": [{ "Language": "en", "Text": "Content for Tutorial" }],
  "ClassTypes": "",
  "Category": "Content",
  "Thumbnail": "MyContentpack.png",
  "Screenshots": ["MyContentpack_Preview.png"]
}
```

### Top-level properties

- `Version` (number)
  - Manifest schema version.
  - Use `1` for this template.

- `Name` (array of localized text objects)
  - Display name shown in Add Feature or Content Pack UI.
  - Supports localization using multiple language entries.

- `Description` (array of localized text objects)
  - Description shown in pack details.
  - Keep concise and user-facing.

- `AssetTypes` (array)
  - Optional grouping labels for asset categories.
  - Can be left empty (`[]`) if not used.

- `SearchTags` (array of localized text objects)
  - Keywords used by Unreal search in the pack dialog.
  - Add relevant terms to improve discoverability.

- `ClassTypes` (string)
  - Optional class filter string.
  - Leave empty (`""`) unless your workflow requires class-based filtering.

- `Category` (string)
  - UI category label for the pack.
  - Typical value: `"Content"`,`"BlueprintFeature"`,`"CodeFeature"`

- `Thumbnail` (string)
  - Main preview image filename.
  - File must exist in `PackageContent/Media/`.

- `Screenshots` (array of strings)
  - Additional preview image filenames.
  - Files must exist in `PackageContent/Media/`.

### Localized text object format

Used by `Name`, `Description`, and `SearchTags` entries:

- `Language` (string)
  - Locale code (for example: `"en"`, `"ko"`, `"ja"`).
- `Text` (string)
  - Displayed text for that locale.

Example with multiple languages:

```json
"Name": [
  { "Language": "en", "Text": "MyContentPack" },
  { "Language": "ko", "Text": "마이 콘텐츠 팩" }
]
```

## Troubleshooting

- Pack does not appear in Unreal:
  - Confirm `.upack` is copied to the same engine version `FeaturePacks` folder.
  - Validate JSON syntax in `PackageContent/manifest.json`.
- Missing preview image:
  - Ensure `Thumbnail` and `Screenshots` filenames exactly match files in `PackageContent/Media/`.
- Build script fails:
  - Verify Unreal Engine path and `UnrealPak.exe` location.

## References

> **<u>📘 [Creating a Custom Content Pack](https://dev.epicgames.com/community/learning/courses/Ra5/unreal-engine-using-tools-templates-and-packs-to-improve-your-editor-workflows/O74/creating-a-custom-content-pack) </u>**
>
> *Learn how to create and use reusable Content Packs in Unreal Engine to improve your workflow.*

> 📺 **<u> [Unreal Engine 5 Tutorial - Custom Content Packs](https://www.youtube.com/watch?v=ladkxp5K0qk) </u>**
>
> *A video tutorial showing how to export and package custom Content Packs for use in other UE5 projects.*

> 📘 **<u>[Unreal Engine — Creating an Asset Pack / Feature Pack](https://dev.epicgames.com/community/learning/tutorials/Xjy9/unreal-engine-creating-an-asset-pack-feature-pack)</u>**
>
> *A Community tutorial showing how to create and organize an Asset Pack / Feature Pack in Unreal Engine for reuse across projects.*

> 📺 **<u>[Unreal Engine 5 – Creating an Asset Pack / Feature Pack (Tutorial)](https://www.youtube.com/watch?v=h7tImSnsAI4)</u>**
>
> *A video walkthrough on building and exporting an Asset Pack / Feature Pack in Unreal Engine 5 for reusable workflows.*

### Extracting Unreal Built in Content / Feature Pack

``` text
"E:\EpicGames\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe" -extract "E:\EpicGames\UE_4.27\FeaturePacks\TP_Puzzle.upack" "E:\Tmp\Pack"
```

``` Text
"E:\EpicGames\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe" -Create=E:\Tmp\Pack\" "E:\EpicGames\UE_4.27\FeaturePacks\TP_Puzzle.upack"
```

> Unreal updated unreal.pak behavior in version 5.5 (?) it now require files that contain list of path to pack 
