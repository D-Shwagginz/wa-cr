require "./spec_helper"

describe WAD::Graphic do
  it "should properly set the graphics" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets.size.should eq 320
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[0].should eq 0x0508
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[1].should eq 0x05D9
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[2].should eq 0x06AA
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[3].should eq 0x077B
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[4].should eq 0x084C
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[5].should eq 0x091D
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[6].should eq 0x09EE
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[7].should eq 0x0ABF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[159].should eq 0x86D7
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[-2].should eq 0x0108A6
    mywad.graphics.find! { |m| m.name == "HELP2" }.columnoffsets[-1].should eq 0x010977

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].topdelta.should eq 0x00
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].length.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].data[0].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].data[-1].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].data[-8].should eq 0xF2
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[0].data[-10].should eq 0xF3

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[1].topdelta.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[1].length.should eq 0x48

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[-1].topdelta.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[-1].length.should eq 0x48
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[-1].data[0].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[-1].data[1].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[0].posts[-1].data[2].should eq 0xCF

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[0].topdelta.should eq 0x00
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[0].length.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[0].data[0].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[0].data[4].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[0].data[-1].should eq 0xF1

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[-1].topdelta.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[-1].length.should eq 0x48
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[-1].data[0].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[-1].data[1].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[1].posts[-1].data[2].should eq 0xCF

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].topdelta.should eq 0x00
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].length.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[0].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[4].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[8].should eq 0xF1
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[9].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[10].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[11].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[12].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[13].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[2].posts[0].data[14].should eq 0xF1

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[0].topdelta.should eq 0x00
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[0].length.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[0].data[0].should eq 0xCE
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[0].data[-1].should eq 0xCF

    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[-1].topdelta.should eq 0x80
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[-1].length.should eq 0x48
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[-1].data[0].should eq 0xCF
    mywad.graphics.find! { |m| m.name == "HELP2" }.columns[-1].posts[-1].data[-1].should eq 0xF5

    texturenamesstart = [
      "HELP1", "HELP2", "CREDIT", "VICTORY2", "TITLEPIC", "PFUB1", "PFUB2",
      *("END0".."END6"), *("AMMNUM0".."AMMNUM9"), "STBAR", *("STGNUM0".."STGNUM9"),
    ]

    (texturenamesstart == mywad.graphics[0...texturenamesstart.size].map(&.name)).should be_true

    texturenamesend = [
      "RP1_1", "RP1_2", *("RP2_1".."RP2_4"), *("SW2_1".."SW2_8"), "DUCT1", "PS15A0", "PS18A0", "SKY2", "SKY3",
    ]

    mywad.graphics[-(texturenamesend.size)..-1].map(&.name)

    (texturenamesend == mywad.graphics[-(texturenamesend.size)..-1].map(&.name)).should be_true
  end

  
end
