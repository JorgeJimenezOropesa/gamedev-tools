# Aseprite Autotile Generator

A simple **Lua** plugin for Aseprite that automates tileset generation.

From a minimal **3x2 tile input** (containing corner and edge variations, see input.png), the script automatically generates a full **47-tile** tileset ready for autotiling (blob bitmasking).

## Installation

1. Open Aseprite and go to `File > Scripts > Open Scripts Folder`.
2. Copy the `autotile.lua` file into that folder.
3. Refresh the scripts in Aseprite (`File > Scripts > Rescan Scripts Folder`).

## How to use

1. **Prepare the Input:**
   * Create a sprite with a size of **3 tiles wide x 2 tiles high**.
   * Draw the base pieces (inner corners, outer corners, and fillers) following the standard layout (BL, BR, TL, TR).
2. **Run the Script:**
   * Go to `File > Scripts > autotile`.
3. **Result:**
   * A new sprite will be generated with the fully expanded tileset, preserving the original color palette.
