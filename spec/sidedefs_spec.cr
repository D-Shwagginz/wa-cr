require "./spec_helper"

describe WAD::Map::Sidedefs do
  it "should properly set map sidedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E3M2" }.sidedefs[210].x_offset.should eq 113
    mywad.maps.find! { |m| m.name == "E1M6" }.sidedefs[1523].name_tex_up.should eq "COMPUTE2"
    mywad.maps.find! { |m| m.name == "E2M1" }.sidedefs[350].name_tex_mid.should eq "SLADWALL"
    mywad.maps.find! { |m| m.name == "E3M6" }.sidedefs[52].facing_sector_num.should eq 4
    mywad.maps.find! { |m| m.name == "E2M4" }.sidedefs[1438].name_tex_low.should eq "GRAYTALL"
  end
end
