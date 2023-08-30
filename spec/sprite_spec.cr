require "./spec_helper"

describe WAD::Graphic do
  it "should properly set the spries" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.sprites[0].name.should eq "CHGGA0"
    mywad.sprites[0].width.should eq 0x72
    mywad.sprites[0].height.should eq 0x53

    mywad.sprites[-1].name.should eq "FCANC0"
    mywad.sprites[-1].width.should eq 0x24
    mywad.sprites[-1].height.should eq 0x33

    texturenamesstart = [
      "CHGGA0", "CHGGB0", "CHGFA0", "CHGFB0", "SAWGA0", "SAWGB0", "SAWGC0",
    ]

    (texturenamesstart == mywad.sprites[0...texturenamesstart.size].map(&.name)).should be_true

    texturenamesend = [
      "PINVA0", "PINVB0", "PINVC0", "PINVD0", "FCANA0", "FCANB0", "FCANC0",
    ]

    (texturenamesend == mywad.sprites[-(texturenamesend.size)..-1].map(&.name)).should be_true
  end
end
