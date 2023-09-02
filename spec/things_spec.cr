require "./spec_helper"

describe WAD::Map::Things do
  it "should properly set map things" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E1M1"].things[0].x_position.should eq 1056
    mywad.maps["E2M2"].things[10].y_position.should eq 3168
    mywad.maps["E3M3"].things[20].angle_facing.should eq 0
    mywad.maps["E3M3"].things[20].thing_type.should eq 2047
    mywad.maps["E2M5"].things[135].flags.should eq 4
  end
end
