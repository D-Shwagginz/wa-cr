require "./wa-cr/**"
require "./write"

wad = WAD.read!("./rsrc/DOOM.WAD")
wad.write("./rsrc/test.wad")
