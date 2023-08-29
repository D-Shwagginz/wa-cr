require "./spec_helper"

describe WAD::Map::Ssectors do
  it "should properly set map ssectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M2" }.ssectors[100].seg_count.should eq 4
    mywad.maps.find! { |m| m.name == "E2M4" }.ssectors[81].first_seg_num.should eq 267
    mywad.maps.find! { |m| m.name == "E3M2" }.ssectors[237].seg_count.should eq 1
    mywad.maps.find! { |m| m.name == "E2M1" }.ssectors[0].seg_count.should eq 5
    mywad.maps.find! { |m| m.name == "E2M5" }.ssectors[338].first_seg_num.should eq 1003
  end
end