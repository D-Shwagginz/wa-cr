require "./wad-reader/**"

mywad = WAD.read("./rsrc/DOOM.WAD")
#pp Parse.reject(mywad, mywad.maps.first.reject)
my_parsed_wad = Parse.wad(mywad)
Parse.things(mywad, mywad.maps.first.things)
