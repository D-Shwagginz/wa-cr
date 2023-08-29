require "./spec_helper"

describe WAD::Map::Segs do
  it "should properly set map segs" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E1M3" }.segs[531].angle.should eq 16384
    mywad.maps.find! { |m| m.name == "E2M4" }.segs[1003].direction.should eq 1
    mywad.maps.find! { |m| m.name == "E3M6" }.segs[163].offset.should eq 146
    mywad.maps.find! { |m| m.name == "E1M2" }.segs[1323].start_vertex_num.should eq 545
    mywad.maps.find! { |m| m.name == "E3M9" }.segs[227].end_vertex_num.should eq 187
  end
end
