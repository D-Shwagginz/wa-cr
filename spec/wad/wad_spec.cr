require "../spec_helper"

describe WAD, tags: "wad" do
  it "should properly read the wad" do
    my_string_wad = WAD.read("./rsrc/DOOM.WAD")

    File.open("./rsrc/DOOM.WAD") do |file|
      my_io_wad = WAD.read(file)
    end
  end
end
