require "../../spec_helper"

describe WAD::Map::Things, tags: "map" do
  it "should properly set map things", tags: "things" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    thing_check(mywad, "E1M1", 87, 2272, -2432, 180, 3004, 15)
    thing_check(mywad, "E1M5", 281, 160, -32, 90, 14, 7)
    thing_check(mywad, "E1M2", 36, 1744, 416, 0, 2014, 7)
    thing_check(mywad, "E2M7", 171, 3568, 1872, 0, 2008, 7)
    thing_check(mywad, "E3M3", 75, -768, 32, 0, 3002, 14)
  end
end
