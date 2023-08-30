require "./wad-reader/**"
require "./raylib"

mywad = WAD.read("./rsrc/DOOM.WAD")
# palette = mywad.playpal.palettes[0]
# test_texture = mywad.get_texture("SUPPORT3", palette)

# R.export_image?(test_texture, "./rsrc/test_texture.png")

# R.unload_image(test_texture)
