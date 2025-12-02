-- autotile_preview.lua
local fs = app.fs
-- Construimos la ruta dinámica al core para que funcione siempre
local core_path = fs.joinPath(fs.userConfigPath, "scripts", "_autotile_core.lua")
local logic = dofile(core_path)

logic.run(false) -- False = Preview Mode
