# Aseprite Autotile Generator

A small Lua plugin for Aseprite that expands a minimal 3x2 tiles input into a complete 47-tile autotile tileset (suitable for blob bitmasking).

## What this repository contains

- `_autotile_core.lua` — core logic (required)
- `autotile_preview.lua` — runs the generator in preview mode (does not auto-export)
- `autotile_export.lua` — runs the generator and exports the tileset as a PNG

## Installation

1. Open Aseprite and go to `File > Scripts > Open Scripts Folder`.
2. Copy these files into that folder:
   - `_autotile_core.lua`
   - `autotile_preview.lua`
   - `autotile_export.lua`
3. Refresh the scripts in Aseprite (`File > Scripts > Rescan Scripts Folder`).

## Usage

1. Prepare the input sprite:
   - Create a sprite that is 3 tiles wide × 2 tiles high.
   - Draw the base pieces (corners and edge pieces) following the expected layout.
2. Run one of the scripts from `File > Scripts`:
   - `autotile_preview` — opens the generated tileset inside Aseprite for inspection.
   - `autotile_export` — exports the tileset PNG next to the source sprite (saves as <sprite>_tileset.png).

The generated sprite preserves the original palette (if present).

## Notes

- The core script relies on the scripts folder being in Aseprite's user config path, which is where you should place `_autotile_core.lua`.