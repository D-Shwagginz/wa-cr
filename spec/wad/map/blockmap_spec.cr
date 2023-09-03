require "../../spec_helper"

describe WAD::Map::Blockmap, tags: "map" do
  it "should properly set map blockmap", tags: "blockmap" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps["E2M1"].blockmap.header.grid_origin_x.should eq -296
    mywad.maps["E3M5"].blockmap.header.num_of_rows.should eq 37
    mywad.maps["E1M8"].blockmap.offsets[3].should eq 2922
    mywad.maps["E2M5"].blockmap.blocklists[5].linedefs_in_block[1].should eq 480
    mywad.maps["E3M1"].blockmap.blocklists[8].linedefs_in_block[2].should eq 1
  end
end
