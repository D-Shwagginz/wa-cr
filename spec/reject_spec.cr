require "./spec_helper"

describe WAD::Map::Reject do
  it "should properly set map reject" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E1M2"].reject[1, 2].should eq false
    mywad.maps["E2M3"].reject[32, 52].should eq true
    mywad.maps["E3M1"].reject[0, 9].should eq false
  end
end
