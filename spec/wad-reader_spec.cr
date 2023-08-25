require "./spec_helper"

describe WAD do
  it "should properly set the wad type" do
    mywad = WAD.read("./rsrc/DOOM.WAD")
    (mywad.type == WAD::Type::Internal).should be_true
  end

  it "should properly set map things" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find!{|m| m.name == "E1M1"}.things[0].x_position.should eq 1056
    mywad.maps.find!{|m| m.name == "E2M2"}.things[10].y_position.should eq 3168
    mywad.maps.find!{|m| m.name == "E3M3"}.things[20].angle_facing.should eq 0
    mywad.maps.find!{|m| m.name == "E3M3"}.things[20].thing_type.should eq 2047
  end
end
