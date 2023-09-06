require "../../spec_helper"

describe WAD::Map::Seg, tags: "map" do
  it "should properly set map segs", tags: "segs" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    seg_check(my_wad, "E2M1", 61, 332, 229, 2960, 267, 0, 114)
    seg_check(my_wad, "E2M6", 1005, 869, 870, 16384, 1048, 0, 0)
    seg_check(my_wad, "E3M1", 297, 29, 46, -16384, 48, 0, 0)
    seg_check(my_wad, "E3M5", 1687, 926, 928, 24576, 1143, 1, 0)
  end
end
