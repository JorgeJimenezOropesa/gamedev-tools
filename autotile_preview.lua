-- autotile_preview.lua
local fs = app.fs
-- Build a dynamic path to the core file so it works regardless of install location
local core_path = fs.joinPath(fs.userConfigPath, "scripts", "_autotile_core.lua")
local logic = dofile(core_path)

-- Run in preview mode (false = preview)
logic.run(false)
