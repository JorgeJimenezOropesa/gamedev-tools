# Aseprite Autotile Generator

Un plugin simple escrito en **Lua** para Aseprite que automatiza la generación de tilesets.

A partir de un input mínimo de **3x2 tiles** (conteniendo las variaciones de esquinas y bordes, ver input.png), el script genera automáticamente un tileset completo de **47 tiles** listo para autotiling (blob bitmasking).

## Instalación

1. Abre Aseprite y ve a `File > Scripts > Open Scripts Folder`.
2. Copia el archivo `autotile.lua` en esa carpeta.
3. Refresca los scripts en Aseprite (`File > Scripts > Rescan Scripts Folder`).

## Cómo usarlo

1. **Prepara el Input:**
   * Crea un sprite cuyo tamaño sea **3 tiles de ancho x 2 tiles de alto**.
   * Dibuja las piezas base (esquinas internas, externas y rellenos) siguiendo la distribución estándar (BL, BR, TL, TR).
2. **Ejecuta el Script:**
   * Ve a `File > Scripts > autotile`.
3. **Resultado:**
   * Se generará un nuevo sprite con el tileset completo expandido, preservando la paleta de colores original.
