require "../../spec_helper"

describe WAD::Map::Sidedefs, tags: "map" do
  it "should properly set map sidedefs", tags: "sidedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    sidedef_check(mywad, "E1M9", 297, 0, 0, "BROWN96", "-", "-", 104)
    sidedef_check(mywad, "E2M4", 671, 0, 0, "STONE3", "STONE3", "-", 52)
    sidedef_check(mywad, "E3M3", 1260, 0, 0, "STONE", "-", "-", 147)
    sidedef_check(mywad, "E3M8", 0, 0, 0, "-", "-", "TEKWALL2", 1)
  end
end
