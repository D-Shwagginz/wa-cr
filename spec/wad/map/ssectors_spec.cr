require "../../spec_helper"

describe WAD::Map::Ssectors, tags: "map" do
  it "should properly set map ssectors", tags: "ssectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    ssector_check(mywad, "E1M1", 110, 1, 333)
    ssector_check(mywad, "E1M6", 427, 1, 1326)
    ssector_check(mywad, "E2M2", 62, 3, 215)
    ssector_check(mywad, "E3M2", 180, 3, 499)
  end
end
