-- autotile.lua
-- Port del script de Python para Aseprite
-- Genera un tileset completo 47-tile bitmasking a partir de un input de 3x2 tiles.

local sprite = app.activeSprite
if not sprite then return app.alert("¡No hay ningún sprite abierto!") end

    -- Asumimos que la imagen activa es el 'input' (fragmentos)
    local cel = app.activeCel
    if not cel then return app.alert("Selecciona una celda con la imagen base.") end
        local input_img = cel.image

        -- Cálculo dinámico del tamaño del tile
        -- El input debe ser de 3 tiles de ancho x 2 tiles de alto
        local tile_size = math.floor(input_img.width / 3)
        local half = math.floor(tile_size / 2)

        -- Verificación de seguridad básica
        if input_img.height < tile_size * 2 then
            return app.alert("La imagen de input parece demasiado pequeña. Debe ser 3x2 tiles.")
            end

            -----------------------------------------------------------
            -- FUNCIONES HELPER (Equivalentes a tu Python)
            -----------------------------------------------------------

            -- Crea una nueva imagen combinando 4 esquinas (Half-tiles)
            local function create_tile(bl, br, tl, tr)
            local img = Image(tile_size, tile_size)
            -- En Aseprite: drawImage(source, x, y)
            img:drawImage(tl, 0, 0)
            img:drawImage(tr, half, 0)
            img:drawImage(bl, 0, half)
            img:drawImage(br, half, half)
            return img
            end

            -- Recorta un trozo de 8x8 (o mitad del tile) del input original
            local function crop_half_tile(x, y)
            local rect = Rectangle(x * half, y * half, half, half)
            -- Constructor de copia con recorte: Image(source, rectangle)
            return Image(input_img, rect)
            end

            -----------------------------------------------------------
            -- PREPARACIÓN DE FRAGMENTOS (Recortes)
            -----------------------------------------------------------

            -- BOTTOM LEFT (bl)
            local bl = {}
            table.insert(bl, crop_half_tile(0, 3)) -- Index 1 (Python 0)
            table.insert(bl, crop_half_tile(2, 3)) -- Index 2 (Python 1)
            table.insert(bl, crop_half_tile(0, 1)) -- Index 3 (Python 2)
            table.insert(bl, crop_half_tile(4, 1)) -- Index 4 (Python 3)
            table.insert(bl, crop_half_tile(2, 1)) -- Index 5 (Python 4)

            -- BOTTOM RIGHT (br)
            local br = {}
            table.insert(br, crop_half_tile(3, 3))
            table.insert(br, crop_half_tile(3, 1))
            table.insert(br, crop_half_tile(1, 3))
            table.insert(br, crop_half_tile(5, 1))
            table.insert(br, crop_half_tile(1, 1))

            -- TOP LEFT (tl)
            local tl = {}
            table.insert(tl, crop_half_tile(0, 0))
            table.insert(tl, crop_half_tile(0, 2))
            table.insert(tl, crop_half_tile(2, 0))
            table.insert(tl, crop_half_tile(4, 0))
            table.insert(tl, crop_half_tile(1, 1))

            -- TOP RIGHT (tr)
            local tr = {}
            table.insert(tr, crop_half_tile(3, 0))
            table.insert(tr, crop_half_tile(1, 0))
            table.insert(tr, crop_half_tile(3, 2))
            table.insert(tr, crop_half_tile(5, 0))
            table.insert(tr, crop_half_tile(1, 2))

            -----------------------------------------------------------
            -- GENERACIÓN DEL TILESET
            -----------------------------------------------------------

            -- Dimensiones de salida: 21 tiles de ancho, 10 de alto
            local output_w = 21 * tile_size
            local output_h = 10 * tile_size
            local final_image = Image(output_w, output_h)

            local x = 0
            local y = 0
            local x_space = 2 * tile_size
            local y_space = 2 * tile_size

            -- Helper para pegar en la imagen final y avanzar cursor si es necesario
            -- Nota: Tu script de Python maneja x/y manualmente, mantendré esa lógica
            -- para asegurar que el layout sea idéntico.

            -- Bloque 0 adyacentes
            final_image:drawImage(create_tile(bl[1], br[1], tl[1], tr[1]), x, y)
            y = y + y_space

            -- Bloque 1 adyacente
            final_image:drawImage(create_tile(bl[3], br[2], tl[1], tr[1]), x, y) -- abajo
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[1], tl[3], tr[1]), x, y) -- izquierda
            x = x + tile_size
            final_image:drawImage(create_tile(bl[1], br[1], tl[2], tr[3]), x, y) -- arriba
            x = x + tile_size
            final_image:drawImage(create_tile(bl[1], br[3], tl[1], tr[2]), x, y) -- derecha

            x = 0
            y = y + y_space

            -- Bloque 2 adyacentes
            final_image:drawImage(create_tile(bl[3], br[2], tl[2], tr[3]), x, y) -- vertical
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[3], tl[3], tr[2]), x, y) -- horizontal
            x = x + x_space

            final_image:drawImage(create_tile(bl[4], br[2], tl[3], tr[1]), x, y) -- ab izq sin esq
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[1], tl[4], tr[3]), x, y) -- ar izq sin esq
            x = x + tile_size
            final_image:drawImage(create_tile(bl[1], br[3], tl[2], tr[4]), x, y) -- ar der sin esq
            x = x + tile_size
            final_image:drawImage(create_tile(bl[3], br[4], tl[1], tr[2]), x, y) -- ab der sin esq
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[2], tl[3], tr[1]), x, y) -- ab izq sin esq (v2)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[1], tl[5], tr[3]), x, y) -- ar izq sin esq (v2)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[1], br[3], tl[2], tr[5]), x, y) -- ar der sin esq (v2)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[3], br[5], tl[1], tr[2]), x, y) -- ab der sin esq (v2)

            x = 0
            y = y + y_space

            -- Bloque 3 adyacentes
            final_image:drawImage(create_tile(bl[4], br[4], tl[3], tr[2]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[2], tl[4], tr[3]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[3], tl[4], tr[4]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[3], br[4], tl[2], tr[4]), x, y)
            x = x + x_space

            -- Bloques complejos con esquinas
            final_image:drawImage(create_tile(bl[5], br[4], tl[3], tr[2]), x, y)
            final_image:drawImage(create_tile(bl[4], br[5], tl[3], tr[2]), x, y + tile_size)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[2], tl[5], tr[3]), x, y)
            final_image:drawImage(create_tile(bl[5], br[2], tl[4], tr[3]), x, y + tile_size)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[3], tl[5], tr[4]), x, y)
            final_image:drawImage(create_tile(bl[2], br[3], tl[4], tr[5]), x, y + tile_size)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[3], br[5], tl[2], tr[4]), x, y)
            final_image:drawImage(create_tile(bl[3], br[4], tl[2], tr[5]), x, y + tile_size)
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[5], tl[3], tr[2]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[5], br[2], tl[5], tr[3]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[2], br[3], tl[5], tr[5]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[3], br[5], tl[2], tr[5]), x, y)

            x = 0
            y = y + y_space + tile_size

            -- Bloque 4 adyacentes (Lleno)
            final_image:drawImage(create_tile(bl[4], br[4], tl[4], tr[4]), x, y) -- Sin esquinas (centro puro)
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[4], tl[4], tr[4]), x, y) -- esq ab izq
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[4], tl[5], tr[4]), x, y) -- esq ar izq
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[4], tl[4], tr[5]), x, y) -- esq ar der
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[5], tl[4], tr[4]), x, y) -- esq ab der
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[5], tl[4], tr[4]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[5], br[4], tl[5], tr[4]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[4], tl[5], tr[5]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[5], tl[4], tr[5]), x, y)
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[4], tl[4], tr[5]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[5], tl[5], tr[4]), x, y)
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[5], tl[5], tr[4]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[5], br[4], tl[5], tr[5]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[4], br[5], tl[5], tr[5]), x, y)
            x = x + tile_size
            final_image:drawImage(create_tile(bl[5], br[5], tl[4], tr[5]), x, y)
            x = x + x_space

            final_image:drawImage(create_tile(bl[5], br[5], tl[5], tr[5]), x, y) -- Todo esquinas

            -- CREAR EL SPRITE DE SALIDA
            local output_sprite = Sprite(output_w, output_h)
            output_sprite:setPalette(sprite.palettes[1]) -- Copiar paleta
            output_sprite.cels[1].image = final_image
            output_sprite.filename = "tileset_output.png"

            app.refresh()
