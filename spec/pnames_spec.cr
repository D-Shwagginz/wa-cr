require "./spec_helper"

describe WAD::Pnames do
  it "should properly set the Pnames" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.pnames.num_patches.should eq 350
    mywad.pnames.patches[0].should eq "WALL00_3"
    mywad.pnames.patches[111].should eq "WALL57_4"
    mywad.pnames.patches[219].should eq "PS18A0"
    mywad.pnames.patches[349].should eq "SW2_4"
  end
end
