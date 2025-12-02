-- ================= CONFIGURACIÓN =================
-- false: Abre el resultado en una nueva pestaña (Editor)
-- true:  Guarda el resultado como .png y cierra (Export)
local EXPORT_DIRECTLY = false
-- =================================================

local sprite = app.activeSprite
if not sprite then return app.alert("¡No hay ningún sprite abierto!") end

    local cel = app.activeCel
    if not cel then return app.alert("Selecciona una celda con la imagen base.") end

        -- Obtener nombre base para exportación
        local path = sprite.filename
        local fs = app.fs
        local path_dir = fs.filePath(path)
        local name_we = fs.fileTitle(path)
        -- Si el archivo no se ha guardado nunca, usaremos el escritorio o home por defecto
        if path == "" then
            path_dir = fs.userDocsPath
            name_we = "autotile_output"
            end

            -----------------------------------------------------------
            -- LÓGICA CORE (Tu algoritmo original encapsulado)
            -----------------------------------------------------------
            local function generate_autotile_image(input_img)
            -- Cálculo dinámico del tamaño del tile
            local tile_size = math.floor(input_img.width / 3)
            local half = math.floor(tile_size / 2)

            -- Verificación de seguridad
            if input_img.height < tile_size * 2 then
                app.alert("La imagen de input parece demasiado pequeña. Debe ser 3x2 tiles.")
                return nil
                end

                -- FUNCIONES HELPER INTERNAS
                local function create_tile(bl, br, tl, tr)
                local img = Image(tile_size, tile_size)
                img:drawImage(tl, 0, 0)
                img:drawImage(tr, half, 0)
                img:drawImage(bl, 0, half)
                img:drawImage(br, half, half)
                return img
                end

                local function crop_half_tile(x, y)
                local rect = Rectangle(x * half, y * half, half, half)
                return Image(input_img, rect)
                end

                -- PREPARACIÓN DE FRAGMENTOS
                local bl, br, tl, tr = {}, {}, {}, {}

                -- BOTTOM LEFT (bl)
                table.insert(bl, crop_half_tile(0, 3)); table.insert(bl, crop_half_tile(2, 3))
                table.insert(bl, crop_half_tile(0, 1)); table.insert(bl, crop_half_tile(4, 1))
                table.insert(bl, crop_half_tile(2, 1))

                -- BOTTOM RIGHT (br)
                table.insert(br, crop_half_tile(3, 3)); table.insert(br, crop_half_tile(3, 1))
                table.insert(br, crop_half_tile(1, 3)); table.insert(br, crop_half_tile(5, 1))
                table.insert(br, crop_half_tile(1, 1))

                -- TOP LEFT (tl)
                table.insert(tl, crop_half_tile(0, 0)); table.insert(tl, crop_half_tile(0, 2))
                table.insert(tl, crop_half_tile(2, 0)); table.insert(tl, crop_half_tile(4, 0))
                table.insert(tl, crop_half_tile(1, 1))

                -- TOP RIGHT (tr)
                table.insert(tr, crop_half_tile(3, 0)); table.insert(tr, crop_half_tile(1, 0))
                table.insert(tr, crop_half_tile(3, 2)); table.insert(tr, crop_half_tile(5, 0))
                table.insert(tr, crop_half_tile(1, 2))

                -- GENERACIÓN DEL TILESET (Layout idéntico al original)
                local output_w = 21 * tile_size
                local output_h = 10 * tile_size
                local final_image = Image(output_w, output_h)

                local x = 0; local y = 0
                local x_space = 2 * tile_size; local y_space = 2 * tile_size

                -- Bloque 0
                final_image:drawImage(create_tile(bl[1], br[1], tl[1], tr[1]), x, y)
                y = y + y_space

                -- Bloque 1
                final_image:drawImage(create_tile(bl[3], br[2], tl[1], tr[1]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[1], tl[3], tr[1]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[1], br[1], tl[2], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[1], br[3], tl[1], tr[2]), x, y)
                x = 0; y = y + y_space

                -- Bloque 2
                final_image:drawImage(create_tile(bl[3], br[2], tl[2], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[3], tl[3], tr[2]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[4], br[2], tl[3], tr[1]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[1], tl[4], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[1], br[3], tl[2], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[3], br[4], tl[1], tr[2]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[2], tl[3], tr[1]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[1], tl[5], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[1], br[3], tl[2], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[3], br[5], tl[1], tr[2]), x, y)
                x = 0; y = y + y_space

                -- Bloque 3
                final_image:drawImage(create_tile(bl[4], br[4], tl[3], tr[2]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[2], tl[4], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[3], tl[4], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[3], br[4], tl[2], tr[4]), x, y); x = x + x_space
                -- Complejos
                final_image:drawImage(create_tile(bl[5], br[4], tl[3], tr[2]), x, y)
                final_image:drawImage(create_tile(bl[4], br[5], tl[3], tr[2]), x, y + tile_size); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[2], tl[5], tr[3]), x, y)
                final_image:drawImage(create_tile(bl[5], br[2], tl[4], tr[3]), x, y + tile_size); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[3], tl[5], tr[4]), x, y)
                final_image:drawImage(create_tile(bl[2], br[3], tl[4], tr[5]), x, y + tile_size); x = x + tile_size
                final_image:drawImage(create_tile(bl[3], br[5], tl[2], tr[4]), x, y)
                final_image:drawImage(create_tile(bl[3], br[4], tl[2], tr[5]), x, y + tile_size); x = x + x_space
                -- Más complejos
                final_image:drawImage(create_tile(bl[5], br[5], tl[3], tr[2]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[5], br[2], tl[5], tr[3]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[2], br[3], tl[5], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[3], br[5], tl[2], tr[5]), x, y)
                x = 0; y = y + y_space + tile_size

                -- Bloque 4
                final_image:drawImage(create_tile(bl[4], br[4], tl[4], tr[4]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[4], tl[4], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[4], tl[5], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[4], tl[4], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[5], tl[4], tr[4]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[5], tl[4], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[5], br[4], tl[5], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[4], tl[5], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[5], tl[4], tr[5]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[4], tl[4], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[5], tl[5], tr[4]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[5], tl[5], tr[4]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[5], br[4], tl[5], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[4], br[5], tl[5], tr[5]), x, y); x = x + tile_size
                final_image:drawImage(create_tile(bl[5], br[5], tl[4], tr[5]), x, y); x = x + x_space
                final_image:drawImage(create_tile(bl[5], br[5], tl[5], tr[5]), x, y)

                return final_image
                end

                -----------------------------------------------------------
                -- EJECUCIÓN
                -----------------------------------------------------------
                local final_img = generate_autotile_image(cel.image)

                if final_img then
                    -- Crear un sprite temporal para manejar la salida
                    local output_sprite = Sprite(final_img.width, final_img.height)
                    output_sprite:setPalette(sprite.palettes[1])
                    output_sprite.cels[1].image = final_img

                    if EXPORT_DIRECTLY then
                        -- MODO EXPORTAR
                        local output_filename = fs.joinPath(path_dir, name_we .. "_tileset.png")

                        -- Guardar sin preguntar (o puedes descomentar la siguiente línea para que pregunte)
                        -- output_filename = app.fs.joinPath(path_dir, name_we .. "_tileset.png")

                        output_sprite:saveCopyAs(output_filename)
                        output_sprite:close() -- Cerramos el sprite temporal inmediatamente
                        app.alert("Tileset exportado a: " .. output_filename)
                        else
                            -- MODO VISUALIZAR (Tu modo original)
                            output_sprite.filename = name_we .. "_tileset.png"
                            app.command.FitScreen()
                            -- No cerramos el sprite, se queda abierto en el editor
                            end
                            end
                            app.refresh()
