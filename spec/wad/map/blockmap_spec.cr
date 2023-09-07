require "../../spec_helper"

describe WAD::Map::Blockmap, tags: "map" do
  it "should properly set map blockmap", tags: "blockmap" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.maps["E2M1"].blockmap.header.grid_origin_x.should eq -296
    my_wad.maps["E3M5"].blockmap.header.num_of_rows.should eq 37
    my_wad.maps["E1M8"].blockmap.offsets[3].should eq 2922
    my_wad.maps["E2M5"].blockmap.blocklists[5].linedefs_in_block[1].should eq 480
    my_wad.maps["E3M1"].blockmap.blocklists[8].linedefs_in_block[2].should eq 1
  end
end
