require "../../spec_helper"

describe WAD::Playpal, tags: "textures" do
  it "should properly set the playpal", tags: "playpal" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.playpal.palettes[0].colors[0].r.should eq 0
    my_wad.playpal.palettes[0].colors[0].g.should eq 0
    my_wad.playpal.palettes[0].colors[0].b.should eq 0
    my_wad.playpal.palettes[3].colors[119].g.should eq 98
    my_wad.playpal.palettes[5].colors[255].r.should eq 215
    my_wad.playpal.palettes[6].colors[75].b.should eq 11
    my_wad.playpal.palettes[13].colors[86].r.should eq 175
    my_wad.playpal.palettes[13].colors[171].g.should eq 167
    my_wad.playpal.palettes[13].colors[255].b.should eq 94
  end
end
