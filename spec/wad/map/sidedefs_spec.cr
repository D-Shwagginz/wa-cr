require "../../spec_helper"

describe WAD::Map::Sidedefs, tags: "map" do
  it "should properly set map sidedefs", tags: "sidedefs" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    sidedef_check(my_wad, "E1M9", 297, 0, 0, "BROWN96", "-", "-", 104)
    sidedef_check(my_wad, "E2M4", 671, 0, 0, "STONE3", "STONE3", "-", 52)
    sidedef_check(my_wad, "E3M3", 1260, 0, 0, "STONE", "-", "-", 147)
    sidedef_check(my_wad, "E3M8", 0, 0, 0, "-", "-", "TEKWALL2", 1)
  end
end
