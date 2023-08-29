require "./spec_helper"

describe WAD::Map::Blockmap do
  it "should properly set map blockmap" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E2M1" }.blockmap.header.grid_origin_x.should eq -296
    mywad.maps.find! { |m| m.name == "E3M5" }.blockmap.header.num_of_rows.should eq 37
    mywad.maps.find! { |m| m.name == "E1M8" }.blockmap.offsets[3].should eq 2922
    mywad.maps.find! { |m| m.name == "E2M5" }.blockmap.blocklists[5].linedefs_in_block[1].should eq 480
    mywad.maps.find! { |m| m.name == "E3M1" }.blockmap.blocklists[8].linedefs_in_block[2].should eq 1
  end
end