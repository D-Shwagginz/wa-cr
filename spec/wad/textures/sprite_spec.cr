require "../../spec_helper"

describe WAD::Graphic, tags: "textures" do
  it "should properly set the spries", tags: "sprites" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.sprites.values[0].width.should eq 0x72
    my_wad.sprites.values[0].height.should eq 0x53

    my_wad.sprites.values[-1].width.should eq 0x24
    my_wad.sprites.values[-1].height.should eq 0x33

    texturenamesstart = [
      "CHGGA0", "CHGGB0", "CHGFA0", "CHGFB0", "SAWGA0", "SAWGB0", "SAWGC0",
    ]

    (texturenamesstart == my_wad.sprites.keys[0...texturenamesstart.size]).should be_true

    texturenamesend = [
      "PINVA0", "PINVB0", "PINVC0", "PINVD0", "FCANA0", "FCANB0", "FCANC0",
    ]

    (texturenamesend == my_wad.sprites.keys[-(texturenamesend.size)..-1]).should be_true
  end
end
