-- _autotile_core.lua
local core = {}

function core.run(export_directly)
local sprite = app.activeSprite
if not sprite then return app.alert("¡No hay sprite!") end
    local cel = app.activeCel
    if not cel then return app.alert("Selecciona celda 3x2") end
        local input = cel.image

        -- Lógica matemática (Tu código optimizado)
        local ts = math.floor(input.width / 3)
        if input.height < ts * 2 then return app.alert("Input debe ser 3x2") end
            local h = math.floor(ts / 2)

            local function I(x,y) return Image(input, Rectangle(x*h,y*h,h,h)) end
            local bl, br, tl, tr = {}, {}, {}, {}
            -- Slicing
            table.insert(bl,I(0,3));table.insert(bl,I(2,3));table.insert(bl,I(0,1));table.insert(bl,I(4,1));table.insert(bl,I(2,1))
            table.insert(br,I(3,3));table.insert(br,I(3,1));table.insert(br,I(1,3));table.insert(br,I(5,1));table.insert(br,I(1,1))
            table.insert(tl,I(0,0));table.insert(tl,I(0,2));table.insert(tl,I(2,0));table.insert(tl,I(4,0));table.insert(tl,I(1,1))
            table.insert(tr,I(3,0));table.insert(tr,I(1,0));table.insert(tr,I(3,2));table.insert(tr,I(5,0));table.insert(tr,I(1,2))

            local out = Image(21*ts, 10*ts)
            local function D(l,r,t,e,dx,dy)
            local m=Image(ts,ts); m:drawImage(tl[t],0,0); m:drawImage(tr[e],h,0)
            m:drawImage(bl[l],0,h); m:drawImage(br[r],h,h); out:drawImage(m,dx,dy)
            end
            -- Assembly (Matriz de generación)
            local x, y, ys = 0, 0, 2*ts
            D(1,1,1,1,x,y); y=y+ys; D(3,2,1,1,x,y); x=x+ts; D(2,1,3,1,x,y); x=x+ts
            D(1,1,2,3,x,y); x=x+ts; D(1,3,1,2,x,y); x=0; y=y+ys
            D(3,2,2,3,x,y); x=x+ts; D(2,3,3,2,x,y); x=x+2*ts; D(4,2,3,1,x,y); x=x+ts
            D(2,1,4,3,x,y); x=x+ts; D(1,3,2,4,x,y); x=x+ts; D(3,4,1,2,x,y); x=x+2*ts
            D(5,2,3,1,x,y); x=x+ts; D(2,1,5,3,x,y); x=x+ts; D(1,3,2,5,x,y); x=x+ts
            D(3,5,1,2,x,y); x=0; y=y+ys; D(4,4,3,2,x,y); x=x+ts; D(4,2,4,3,x,y); x=x+ts
            D(2,3,4,4,x,y); x=x+ts; D(3,4,2,4,x,y); x=x+2*ts; D(5,4,3,2,x,y)
            D(4,5,3,2,x,y+ts); x=x+ts; D(4,2,5,3,x,y); D(5,2,4,3,x,y+ts); x=x+ts
            D(2,3,5,4,x,y); D(2,3,4,5,x,y+ts); x=x+ts; D(3,5,2,4,x,y)
            D(3,4,2,5,x,y+ts); x=x+2*ts; D(5,5,3,2,x,y); x=x+ts; D(5,2,5,3,x,y)
            x=x+ts; D(2,3,5,5,x,y); x=x+ts; D(3,5,2,5,x,y); x=0; y=y+ys+ts
            D(4,4,4,4,x,y); x=x+2*ts; D(5,4,4,4,x,y); x=x+ts; D(4,4,5,4,x,y); x=x+ts
            D(4,4,4,5,x,y); x=x+ts; D(4,5,4,4,x,y); x=x+2*ts; D(5,5,4,4,x,y); x=x+ts
            D(5,4,5,4,x,y); x=x+ts; D(4,4,5,5,x,y); x=x+ts; D(4,5,4,5,x,y); x=x+2*ts
            D(5,4,4,5,x,y); x=x+ts; D(4,5,5,4,x,y); x=x+2*ts; D(5,5,5,4,x,y); x=x+ts
            D(5,4,5,5,x,y); x=x+ts; D(4,5,5,5,x,y); x=x+ts; D(5,5,4,5,x,y); x=x+2*ts
            D(5,5,5,5,x,y)

            -- Output Handling
            local outSprite = Sprite(out.width, out.height)
            outSprite:setPalette(sprite.palettes[1])
            outSprite.cels[1].image = out

            local fs = app.fs
            local path = sprite.filename
            local dir = fs.filePath(path)
            local name = fs.fileTitle(path)
            if path == "" then dir = fs.userDocsPath; name="autotile" end
                local filename = fs.joinPath(dir, name .. "_tileset.png")

                if export_directly then
                    outSprite:saveCopyAs(filename)
                    outSprite:close()
                    app.alert("Exportado: " .. filename)
                    else
                        outSprite.filename = filename
                        app.command.FitScreen()
                        end
                        app.refresh()
                        end

                        return core
