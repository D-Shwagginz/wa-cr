require "../../spec_helper"

describe WAD::Flat, tags: "textures" do
  it "should properly set the flats", tags: "flats" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    texturenamesstart = [
      "FLOOR0_1", "FLOOR0_3", "FLOOR0_6", "FLOOR1_1", "FLOOR1_7", "FLOOR3_3", "FLOOR4_1",
    ]

    (texturenamesstart == my_wad.flats.keys[0...texturenamesstart.size]).should be_true

    texturenamesend = [
      "FLAT3", "FLAT4", "FLAT8", "FLAT9", "FLAT17", "FLAT19", "COMP01",
    ]

    (texturenamesend == my_wad.flats.keys[-(texturenamesend.size)..-1]).should be_true

    my_wad.flats.values[0].colors[0].should eq 0x8B
    my_wad.flats.values[0].colors[-1].should eq 0x8C
    my_wad.flats.values[-1].colors[0].should eq 0x60
    my_wad.flats.values[-1].colors[-1].should eq 0x5F
  end
end
