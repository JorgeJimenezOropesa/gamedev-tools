-- autotile_export.lua
local fs = app.fs
-- Build a dynamic path to the core file so it works regardless of install location
local core_path = fs.joinPath(fs.userConfigPath, "scripts", "_autotile_core.lua")
local logic = dofile(core_path)

-- Run in export mode (true = export directly to PNG)
logic.run(true)
