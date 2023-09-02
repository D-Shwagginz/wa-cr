require "./spec_helper"

describe WAD::Flat do
  it "should properly set the flats" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    texturenamesstart = [
      "FLOOR0_1", "FLOOR0_3", "FLOOR0_6", "FLOOR1_1", "FLOOR1_7", "FLOOR3_3", "FLOOR4_1",
    ]

    (texturenamesstart == mywad.flats.keys[0...texturenamesstart.size]).should be_true

    texturenamesend = [
      "FLAT3", "FLAT4", "FLAT8", "FLAT9", "FLAT17", "FLAT19", "COMP01",
    ]

    (texturenamesend == mywad.flats.keys[-(texturenamesend.size)..-1]).should be_true

    mywad.flats.values[0].colors[0].should eq 0x8B
    mywad.flats.values[0].colors[-1].should eq 0x8C
    mywad.flats.values[-1].colors[0].should eq 0x60
    mywad.flats.values[-1].colors[-1].should eq 0x5F
  end
end
