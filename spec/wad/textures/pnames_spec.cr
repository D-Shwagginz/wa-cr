require "../../spec_helper"

describe WAD::Pnames, tags: "textures" do
  it "should properly set the Pnames", tags: "pnames" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.pnames.num_patches.should eq 350
    my_wad.pnames.patches[0].gsub("\u0000", "").should eq "WALL00_3"
    my_wad.pnames.patches[111].gsub("\u0000", "").should eq "WALL57_4"
    my_wad.pnames.patches[219].gsub("\u0000", "").should eq "PS18A0"
    my_wad.pnames.patches[349].gsub("\u0000", "").should eq "SW2_4"
  end
end
