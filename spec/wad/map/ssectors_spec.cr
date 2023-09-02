require "../../spec_helper"

describe WAD::Map::Ssectors, tags: "map" do
  it "should properly set map ssectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E1M2"].ssectors[100].seg_count.should eq 4
    mywad.maps["E2M4"].ssectors[81].first_seg_num.should eq 267
    mywad.maps["E3M2"].ssectors[237].seg_count.should eq 1
    mywad.maps["E2M1"].ssectors[0].seg_count.should eq 5
    mywad.maps["E2M5"].ssectors[338].first_seg_num.should eq 1003
  end
end
