require "../../spec_helper"

describe WAD::Map::Sectors, tags: "map" do
  it "should properly set map sectors", tags: "sectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    sector_check(mywad, "E2M2", 203, 64, 128, "CRATOP2", "CEIL3_4", 160, 0, 0)
    sector_check(mywad, "E2M6", 37, 72, 200, "FLAT4", "FLAT14", 144, 0, 0)
    sector_check(mywad, "E3M1", 1, 0, 88, "FLOOR6_2", "F_SKY1", 255, 0, 0)
    sector_check(mywad, "E3M9", 70, 120, 120, "MFLR8_1", "F_SKY1", 176, 0, 8)
  end
end
