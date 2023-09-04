require "../../spec_helper"

describe WAD::Pnames, tags: "textures" do
  it "should properly set the EnDoom", tags: "endoom" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.endoom.characters[0].ascii_value.should eq 32
    my_wad.endoom.characters[0].color.should eq 14
    my_wad.endoom.characters[1].ascii_value.should eq 32
    my_wad.endoom.characters[1].color.should eq 15
    my_wad.endoom.characters[-1].ascii_value.should eq 32
    my_wad.endoom.characters[-1].color.should eq 7
  end
end
