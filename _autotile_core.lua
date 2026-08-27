-- _autotile_core.lua
local core = {}

-- Run the autotile generator.
-- @param export_directly boolean: if true, saves the generated tileset PNG automatically.
function core.run(export_directly)
    local sprite = app.activeSprite
    if not sprite then return app.alert("No active sprite.") end

    local cel = app.activeCel
    if not cel then return app.alert("Please select an active 3x2 cel.") end
    local input = cel.image

    -- Core logic (optimized)
    -- ts: tile size in pixels (derived from input width / 3)
    local ts = math.floor(input.width / 3)
    if input.height < ts * 2 then return app.alert("Input must be at least 3x2 tiles.") end
    local h = math.floor(ts / 2) -- half-tile size

    -- Helper: slice the input image into small h x h images
    local function I(x, y) return Image(input, Rectangle(x * h, y * h, h, h)) end
    local bl, br, tl, tr = {}, {}, {}, {}

    -- Slicing (populate corner/edge pieces lists)
    table.insert(bl, I(0, 3)); table.insert(bl, I(2, 3)); table.insert(bl, I(0, 1)); table.insert(bl, I(4, 1)); table.insert(bl, I(2, 1))
    table.insert(br, I(3, 3)); table.insert(br, I(3, 1)); table.insert(br, I(1, 3)); table.insert(br, I(5, 1)); table.insert(br, I(1, 1))
    table.insert(tl, I(0, 0)); table.insert(tl, I(0, 2)); table.insert(tl, I(2, 0)); table.insert(tl, I(4, 0)); table.insert(tl, I(1, 1))
    table.insert(tr, I(3, 0)); table.insert(tr, I(1, 0)); table.insert(tr, I(3, 2)); table.insert(tr, I(5, 0)); table.insert(tr, I(1, 2))

    local out = Image(21 * ts, 10 * ts)

    -- D: draw a composed tile (using indices into the slices) onto out at dx,dy
    local function D(l, r, t, e, dx, dy)
        local m = Image(ts, ts)
        m:drawImage(tl[t], 0, 0); m:drawImage(tr[e], h, 0)
        m:drawImage(bl[l], 0, h); m:drawImage(br[r], h, h)
        out:drawImage(m, dx, dy)
    end

    -- Assembly (generation matrix)
    local x, y, ys = 0, 0, 2 * ts
    D(1,1,1,1,x,y); y=y+ys; 
    D(3,2,1,1,x,y); x=x+ts; 
    D(2,1,3,1,x,y); x=x+ts;
    D(1,1,2,3,x,y); x=x+ts; 
    D(1,3,1,2,x,y); x=0; y=y+ys;
    D(3,2,2,3,x,y); x=x+ts; 
    D(2,3,3,2,x,y); x=x+2*ts; 
    D(4,2,3,1,x,y); x=x+ts;
    D(2,1,4,3,x,y); x=x+ts; 
    D(1,3,2,4,x,y); x=x+ts; 
    D(3,4,1,2,x,y); x=x+2*ts;
    D(5,2,3,1,x,y); x=x+ts; 
    D(2,1,5,3,x,y); x=x+ts; 
    D(1,3,2,5,x,y); x=x+ts
    D(3,5,1,2,x,y); x=0; y=y+ys; 
    D(4,4,3,2,x,y); x=x+ts; 
    D(4,2,4,3,x,y); x=x+ts;
    D(2,3,4,4,x,y); x=x+ts; 
    D(3,4,2,4,x,y); x=x+2*ts; 
    D(5,4,3,2,x,y);
    D(4,5,3,2,x,y+ts); x=x+ts; 
    D(4,2,5,3,x,y); 
    D(5,2,4,3,x,y+ts); x=x+ts;
    D(2,3,5,4,x,y); 
    D(2,3,4,5,x,y+ts); x=x+ts; 
    D(3,5,2,4,x,y);
    D(3,4,2,5,x,y+ts); x=x+2*ts; 
    D(5,5,3,2,x,y); x=x+ts; 
    D(5,2,5,3,x,y); x=x+ts; 
    D(2,3,5,5,x,y); x=x+ts; 
    D(3,5,2,5,x,y); x=0; y=y+ys+ts;
    D(4,4,4,4,x,y); x=x+2*ts; 
    D(5,4,4,4,x,y); x=x+ts; 
    D(4,4,5,4,x,y); x=x+ts;
    D(4,4,4,5,x,y); x=x+ts; 
    D(4,5,4,4,x,y); x=x+2*ts; 
    D(5,5,4,4,x,y); x=x+ts;
    D(5,4,5,4,x,y); x=x+ts; 
    D(4,4,5,5,x,y); x=x+ts; 
    D(4,5,4,5,x,y); x=x+2*ts;
    D(5,4,4,5,x,y); x=x+ts; 
    D(4,5,5,4,x,y); x=x+2*ts; 
    D(5,5,5,4,x,y); x=x+ts;
    D(5,4,5,5,x,y); x=x+ts; 
    D(4,5,5,5,x,y); x=x+ts; 
    D(5,5,4,5,x,y); x=x+2*ts;
    D(5,5,5,5,x,y);

    -- Output handling: create a new sprite and attach the generated image
    local outSprite = Sprite(out.width, out.height)
    if sprite.palettes and sprite.palettes[1] then
        outSprite:setPalette(sprite.palettes[1])
    end
    outSprite.cels[1].image = out

    local fs = app.fs
    local path = sprite.filename
    local dir = fs.filePath(path)
    local name = fs.fileTitle(path)
    local filename = fs.joinPath(dir, name .. "_tilesheet.png")

    if export_directly then
        outSprite:saveCopyAs(filename)
        outSprite:close()
        app.alert("Exported: " .. filename)
    else
        -- Set the filename for the generated sprite so the user can save it manually
        outSprite.filename = filename
        app.command.FitScreen()
    end

    app.refresh()
end

return core
