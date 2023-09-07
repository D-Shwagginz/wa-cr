require "../../spec_helper"

describe WAD::Map::Reject, tags: "map" do
  it "should properly set map reject", tags: "reject" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.maps["E1M2"].reject[1, 2].should eq false
    my_wad.maps["E2M3"].reject[32, 52].should eq true
    my_wad.maps["E3M1"].reject[0, 9].should eq false
  end
end
