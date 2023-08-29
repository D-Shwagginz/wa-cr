require "./spec_helper"

describe WAD::Map::Sectors do
  it "should properly set map sectors" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M5" }.sectors[29].floor_height.should eq -176
    mywad.maps.find! { |m| m.name == "E2M4" }.sectors[178].name_tex_floor.should eq "BLOOD3"
    mywad.maps.find! { |m| m.name == "E3M8" }.sectors[7].ceiling_height.should eq 128
    mywad.maps.find! { |m| m.name == "E3M3" }.sectors[97].light_level.should eq 128
    mywad.maps.find! { |m| m.name == "E2M2" }.sectors[182].special_type.should eq 0
  end
end