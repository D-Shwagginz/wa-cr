require "./spec_helper"

describe WAD::Playpal do
  it "should properly set the playpal" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.playpal.palettes[0].colors[0].r.should eq 0
    mywad.playpal.palettes[0].colors[0].g.should eq 0
    mywad.playpal.palettes[0].colors[0].b.should eq 0
    mywad.playpal.palettes[3].colors[119].g.should eq 98
    mywad.playpal.palettes[5].colors[255].r.should eq 215
    mywad.playpal.palettes[6].colors[75].b.should eq 11
    mywad.playpal.palettes[13].colors[86].r.should eq 175
    mywad.playpal.palettes[13].colors[171].g.should eq 167
    mywad.playpal.palettes[13].colors[255].b.should eq 94
  end
end