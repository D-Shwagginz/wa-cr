require "../../spec_helper"

describe WAD::TextureX, tags: "textures" do
  it "should properly set the textureX's", tags: "texturex" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.texmaps.values[0].numtextures.should eq 125
    my_wad.texmaps.values[0].offsets[0].should eq 504
    my_wad.texmaps.values[0].offsets[1].should eq 546
    my_wad.texmaps.values[0].offsets[2].should eq 618
    my_wad.texmaps.values[1].offsets[0].should eq 648
    my_wad.texmaps.values[1].offsets[1].should eq 680
    my_wad.texmaps.values[1].offsets[2].should eq 712
    my_wad.texmaps.values[0].mtextures[0].name.gsub("\u0000", "").should eq "AASTINKY"
    my_wad.texmaps.values[0].mtextures[0].width.should eq 24
    my_wad.texmaps.values[0].mtextures[0].patches[1].originx.should eq 12
    my_wad.texmaps.values[1].mtextures[0].name.gsub("\u0000", "").should eq "ASHWALL"
    my_wad.texmaps.values[1].mtextures[0].height.should eq 128
    my_wad.texmaps.values[1].mtextures[0].patches[0].originx.should eq 0
  end
end
