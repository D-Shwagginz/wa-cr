require "./spec_helper"

describe WAD::Map::Linedefs do
  it "should properly set map linedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E1M4"].linedefs[293].back_sidedef.should eq 316
    mywad.maps["E2M6"].linedefs[823].front_sidedef.should eq 1004
    mywad.maps["E3M1"].linedefs[93].end_vertex.should eq 87
    mywad.maps["E2M8"].linedefs[179].special_type.should eq 0
    mywad.maps["E1M9"].linedefs[202].sector_tag.should eq 12
  end
end
