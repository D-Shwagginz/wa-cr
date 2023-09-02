require "./spec_helper"

describe WAD::TextureX do
  it "should properly set the textureX's" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.texmaps.values[0].numtextures.should eq 125
    mywad.texmaps.values[0].offsets[0].should eq 504
    mywad.texmaps.values[0].offsets[1].should eq 546
    mywad.texmaps.values[0].offsets[2].should eq 618
    mywad.texmaps.values[1].offsets[0].should eq 648
    mywad.texmaps.values[1].offsets[1].should eq 680
    mywad.texmaps.values[1].offsets[2].should eq 712
    mywad.texmaps.values[0].mtextures[0].name.gsub("\u0000", "").should eq "AASTINKY"
    mywad.texmaps.values[0].mtextures[0].width.should eq 24
    mywad.texmaps.values[0].mtextures[0].patches[1].originx.should eq 12
    mywad.texmaps.values[1].mtextures[0].name.gsub("\u0000", "").should eq "ASHWALL"
    mywad.texmaps.values[1].mtextures[0].height.should eq 128
    mywad.texmaps.values[1].mtextures[0].patches[0].originx.should eq 0
  end
end
