require "../../spec_helper"

describe WAD::Graphic, tags: "textures" do
  it "should properly set the graphics", tags: "graphics" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    texturenamesstart = [
      "HELP1", "HELP2", "CREDIT", "VICTORY2", "TITLEPIC", "PFUB1", "PFUB2",
      *("END0".."END6"), *("AMMNUM0".."AMMNUM9"), "STBAR", *("STGNUM0".."STGNUM9"),
    ]

    (texturenamesstart == my_wad.graphics.keys[0...texturenamesstart.size]).should be_true

    texturenamesend = [
      "RP1_1", "RP1_2", *("RP2_1".."RP2_4"), *("SW2_1".."SW2_8"), "DUCT1", "PS15A0", "PS18A0", "SKY2", "SKY3",
    ]

    (texturenamesend == my_wad.graphics.keys[-(texturenamesend.size)..-1]).should be_true
  end
end
