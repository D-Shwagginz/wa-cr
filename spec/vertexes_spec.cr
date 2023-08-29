require "./spec_helper"

describe WAD::Map::Vertexes do
  it "should properly set map vertexes" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M7" }.vertexes[695].x_position.should eq 1664
    mywad.maps.find! { |m| m.name == "E2M8" }.vertexes[78].y_position.should eq -224
    mywad.maps.find! { |m| m.name == "E3M5" }.vertexes[1198].x_position.should eq -16
    mywad.maps.find! { |m| m.name == "E1M3" }.vertexes[382].y_position.should eq -2304
    mywad.maps.find! { |m| m.name == "E3M2" }.vertexes[0].x_position.should eq 1984
  end
end
