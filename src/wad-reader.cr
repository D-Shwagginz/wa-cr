require "./wad-reader/**"
require "./raylib"
require "./write"

mywad = WAD.read("./rsrc/TNT.WAD")
File.open("./rsrc/mynewwad.WAD", "w+") do |file|
  mywad.write(file)
end

# palette = mywad.playpal.palettes[0]
# test_texture = mywad.get_texture("SUPPORT3", palette)

# R.export_image?(test_texture, "./rsrc/test_texture.png")

# R.unload_image(test_texture)
