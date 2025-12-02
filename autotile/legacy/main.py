from PIL import Image

tile_size = 16


def create_tile(bl, br, tl, tr):
    half = tile_size // 2
    img = Image.new("RGBA", (tile_size, tile_size))
    img.paste(tl, (0, 0), tl)
    img.paste(tr, (half, 0), tr)
    img.paste(bl, (0, half), bl)
    img.paste(br, (half, half), br)
    return img

def crop_half_tile(x, y):
    half_tile = tile_size // 2
    return fragments.crop((x * half_tile, y * half_tile, (x + 1) * half_tile, (y + 1) * half_tile))

fragments = Image.open("input.png")

# ========= Guardar los fragmentos ==========
# BOTTOM LEFT
bl = []
bl.append(crop_half_tile(0, 3))
bl.append(crop_half_tile(2, 3))
bl.append(crop_half_tile(0, 1))
bl.append(crop_half_tile(4, 1))
bl.append(crop_half_tile(2, 1))

# BOTTOM RIGHT
br = []
br.append(crop_half_tile(3, 3))
br.append(crop_half_tile(3, 1))
br.append(crop_half_tile(1, 3))
br.append(crop_half_tile(5, 1))
br.append(crop_half_tile(1, 1))

# TOP LEFT
tl = []
tl.append(crop_half_tile(0, 0))
tl.append(crop_half_tile(0, 2))
tl.append(crop_half_tile(2, 0))
tl.append(crop_half_tile(4, 0))
tl.append(crop_half_tile(1, 1))

# TOP RIGHT
tr = []
tr.append(crop_half_tile(3, 0))
tr.append(crop_half_tile(1, 0))
tr.append(crop_half_tile(3, 2))
tr.append(crop_half_tile(5, 0))
tr.append(crop_half_tile(1, 2))

# ========== Crear el tilemap ==========
tileset = Image.new("RGBA", (21 * tile_size, 10 * tile_size))
x = 0
y = 0
x_space = 2*tile_size
y_space = 2*tile_size

# 0 adyacentes
tileset.paste(create_tile(bl[0], br[0], tl[0], tr[0]), (x, y))
y += y_space

# 1 adyacente
tileset.paste(create_tile(bl[2], br[1], tl[0], tr[0]), (x, y)) # abajo
x += tile_size
tileset.paste(create_tile(bl[1], br[0], tl[2], tr[0]), (x, y)) # izquierda
x += tile_size
tileset.paste(create_tile(bl[0], br[0], tl[1], tr[2]), (x, y)) # arriba
x += tile_size
tileset.paste(create_tile(bl[0], br[2], tl[0], tr[1]), (x, y)) # derecha

x = 0
y += y_space

# 2 adyacentes
tileset.paste(create_tile(bl[2], br[1], tl[1], tr[2]), (x, y)) # vertical
x += tile_size
tileset.paste(create_tile(bl[1], br[2], tl[2], tr[1]), (x, y)) # horizontal
x += x_space

tileset.paste(create_tile(bl[3], br[1], tl[2], tr[0]), (x, y)) # abajo izquierda sin esquina
x += tile_size
tileset.paste(create_tile(bl[1], br[0], tl[3], tr[2]), (x, y)) # arriba izquierda sin esquina
x += tile_size
tileset.paste(create_tile(bl[0], br[2], tl[1], tr[3]), (x, y)) # arriba derecha sin esquina
x += tile_size
tileset.paste(create_tile(bl[2], br[3], tl[0], tr[1]), (x, y)) # abajo derecha sin esquina
x += x_space

tileset.paste(create_tile(bl[4], br[1], tl[2], tr[0]), (x, y)) # abajo izquierda sin esquina
x += tile_size
tileset.paste(create_tile(bl[1], br[0], tl[4], tr[2]), (x, y)) # arriba izquierda sin esquina
x += tile_size
tileset.paste(create_tile(bl[0], br[2], tl[1], tr[4]), (x, y)) # arriba derecha sin esquina
x += tile_size
tileset.paste(create_tile(bl[2], br[4], tl[0], tr[1]), (x, y)) # abajo derecha sin esquina

x = 0
y += y_space

# 3 adyacentes
tileset.paste(create_tile(bl[3], br[3], tl[2], tr[1]), (x, y)) # abajo izquierda derecha sin esquinas
x += tile_size
tileset.paste(create_tile(bl[3], br[1], tl[3], tr[2]), (x, y)) # abajo izquierda arriba sin esquinas
x += tile_size
tileset.paste(create_tile(bl[1], br[2], tl[3], tr[3]), (x, y)) # arriba izquierda derecha sin esquinas
x += tile_size
tileset.paste(create_tile(bl[2], br[3], tl[1], tr[3]), (x, y)) # abajo derecha arriba sin esquinas
x += x_space

tileset.paste(create_tile(bl[4], br[3], tl[2], tr[1]), (x, y)) # abajo izquierda derecha esquina izquierda
tileset.paste(create_tile(bl[3], br[4], tl[2], tr[1]), (x, y + tile_size)) # abajo derecha arriba esquina derecha
x += tile_size
tileset.paste(create_tile(bl[3], br[1], tl[4], tr[2]), (x, y)) # arriba izquierda abajo esquina arriba
tileset.paste(create_tile(bl[4], br[1], tl[3], tr[2]), (x, y + tile_size)) # arriba izquierda abajo esquina abajo
x += tile_size
tileset.paste(create_tile(bl[1], br[2], tl[4], tr[3]), (x, y)) # arriba izquierda derecha esquina izquierda
tileset.paste(create_tile(bl[1], br[2], tl[3], tr[4]), (x, y + tile_size)) # arriba izquierda derecha esquina derecha
x += tile_size
tileset.paste(create_tile(bl[2], br[4], tl[1], tr[3]), (x, y)) # arriba derecha abajo esquina arriba
tileset.paste(create_tile(bl[2], br[3], tl[1], tr[4]), (x, y + tile_size)) # arriba derecha abajo esquina abajo
x += x_space

tileset.paste(create_tile(bl[4], br[4], tl[2], tr[1]), (x, y)) # abajo izquierda derecha con esquinas
x += tile_size
tileset.paste(create_tile(bl[4], br[1], tl[4], tr[2]), (x, y)) # arriba izquierda abajo con esquinas
x += tile_size
tileset.paste(create_tile(bl[1], br[2], tl[4], tr[4]), (x, y)) # arriba izquierda derecha con esquinas
x += tile_size
tileset.paste(create_tile(bl[2], br[4], tl[1], tr[4]), (x, y)) # arriba derecha abajo con esquinass

x = 0
y += y_space + tile_size

# 4 adyacentes
tileset.paste(create_tile(bl[3], br[3], tl[3], tr[3]), (x, y)) # sin esquinas
x += x_space

tileset.paste(create_tile(bl[4], br[3], tl[3], tr[3]), (x, y)) # esquina abajo izquierda
x += tile_size
tileset.paste(create_tile(bl[3], br[3], tl[4], tr[3]), (x, y)) # esquina arriba izquierda
x += tile_size
tileset.paste(create_tile(bl[3], br[3], tl[3], tr[4]), (x, y)) # esquina arriba derecha
x += tile_size
tileset.paste(create_tile(bl[3], br[4], tl[3], tr[3]), (x, y)) # esquina abajo derecha
x += x_space


tileset.paste(create_tile(bl[4], br[4], tl[3], tr[3]), (x, y)) #esquina abajo izquierda y abajo derecha
x += tile_size
tileset.paste(create_tile(bl[4], br[3], tl[4], tr[3]), (x, y)) # esquina arriba izquierda y abajo izquierda
x += tile_size
tileset.paste(create_tile(bl[3], br[3], tl[4], tr[4]), (x, y)) # esquina arriba izquierda y arriba derecha
x += tile_size
tileset.paste(create_tile(bl[3], br[4], tl[3], tr[4]), (x, y)) # esquina arriba derecha y abajo derecha
x += x_space

tileset.paste(create_tile(bl[4], br[3], tl[3], tr[4]), (x, y)) # esquina abajo izquierda y arriba derecha
x += tile_size
tileset.paste(create_tile(bl[3], br[4], tl[4], tr[3]), (x, y)) # esquina arriba izquierda y abajo derecha
x += x_space

tileset.paste(create_tile(bl[4], br[4], tl[4], tr[3]), (x, y)) # sin esquina arriba derecha
x += tile_size
tileset.paste(create_tile(bl[4], br[3], tl[4], tr[4]), (x, y)) # sin esquina abajo derecha
x += tile_size
tileset.paste(create_tile(bl[3], br[4], tl[4], tr[4]), (x, y)) # sin esquina abajo izquierda
x += tile_size
tileset.paste(create_tile(bl[4], br[4], tl[3], tr[4]), (x, y)) # sin esquina arriba izquierda
x += x_space

tileset.paste(create_tile(bl[4], br[4], tl[4], tr[4]), (x, y)) # con esquinas

tileset.save("output.png")