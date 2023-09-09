require "./wa-cr/**"
require "./raylib"
require "./write"

my_wad = WAD.read("./rsrc/DOOM.WAD")

palette = my_wad.playpal.palettes[0]

my_wad.export_texture("STARTAN3", "./rsrc/texture", palette)
