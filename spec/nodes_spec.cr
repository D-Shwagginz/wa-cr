require "./spec_helper"

describe WAD::Map::Nodes do
  it "should properly set map nodes" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.maps.find! { |m| m.name == "E2M4" }.nodes[284].right_bound_box[1].should eq -1152
    mywad.maps.find! { |m| m.name == "E1M3" }.nodes[303].y_coord.should eq -2112
    mywad.maps.find! { |m| m.name == "E2M5" }.nodes[473].x_coord.should eq -1920
    mywad.maps.find! { |m| m.name == "E1M9" }.nodes[286].left_bound_box[3].should eq 2688
    mywad.maps.find! { |m| m.name == "E3M2" }.nodes[110].right_child.should eq 103
  end  
end