require "./spec_helper"

describe WAD::Map::Reject do
  it "should properly set map reject" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M2" }.reject[1, 2].should eq false
    mywad.maps.find! { |m| m.name == "E2M3" }.reject[32, 52].should eq true
    mywad.maps.find! { |m| m.name == "E3M1" }.reject[0, 9].should eq true
  end
end
