require "../../spec_helper"

describe WAD::Map::Ssector, tags: "map" do
  it "should properly set map ssectors", tags: "ssectors" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    ssector_check(my_wad, "E1M1", 110, 1, 333)
    ssector_check(my_wad, "E1M6", 427, 1, 1326)
    ssector_check(my_wad, "E2M2", 62, 3, 215)
    ssector_check(my_wad, "E3M2", 180, 3, 499)
  end
end
