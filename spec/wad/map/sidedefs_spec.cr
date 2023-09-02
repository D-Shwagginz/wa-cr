require "../../spec_helper"

describe WAD::Map::Sidedefs, tags: "map" do
  it "should properly set map sidedefs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E3M2"].sidedefs[210].x_offset.should eq 113
    mywad.maps["E1M6"].sidedefs[1523].name_tex_up.gsub("\u0000", "").should eq "COMPUTE2"
    mywad.maps["E2M1"].sidedefs[350].name_tex_mid.gsub("\u0000", "").should eq "SLADWALL"
    mywad.maps["E3M6"].sidedefs[52].facing_sector_num.should eq 4
    mywad.maps["E2M4"].sidedefs[1438].name_tex_low.gsub("\u0000", "").should eq "GRAYTALL"
  end
end
