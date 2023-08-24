require "./wad-reader/**"

mywad = WAD.read("./rsrc/DOOM.WAD")
pp Parse.things(mywad, mywad.maps.first.things)