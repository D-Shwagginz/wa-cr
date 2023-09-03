require "../../spec_helper"

describe WAD::Map::Linedefs, tags: "map" do
  it "should properly set map linedefs", tags: "linedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    linedef_check(mywad, "E1M1", 66, 53, 49, 17, 0, 0, 81, -1)
    linedef_check(mywad, "E1M5", 689, 567, 568, 1, 0, 0, 864, -1)
    linedef_check(mywad, "E2M8", 57, 38, 43, 4, 0, 0, 102, 103)
    linedef_check(mywad, "E2M1", 405, 278, 316, 20, 0, 0, 536, 537)
    linedef_check(mywad, "E2M6", 1014, 849, 850, 9, 0, 0, 1225, -1)
  end
end
