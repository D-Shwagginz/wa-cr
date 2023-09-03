require "./wa-cr/**"
require "./raylib"
require "./write"

mywad = WAD.read("./rsrc/DOOM.WAD")
File.open("./rsrc/mynewwad.WAD", "w+") do |file|
  mywad.write(file)
end
