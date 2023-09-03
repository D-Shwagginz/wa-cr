require "../../spec_helper"

describe WAD::Pnames, tags: "textures" do
  it "should properly set the EnDoom", tags: "endoom" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.endoom.characters[0].ascii_value.should eq 32
    mywad.endoom.characters[0].color.should eq 14
    mywad.endoom.characters[1].ascii_value.should eq 32
    mywad.endoom.characters[1].color.should eq 15
    mywad.endoom.characters[-1].ascii_value.should eq 32
    mywad.endoom.characters[-1].color.should eq 7
  end
end
