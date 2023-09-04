require "../../spec_helper"

describe WAD::Dmxgus, tags: "sounds" do
  it "should properly set the dmxgus", tags: "dmxgus" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.dmxgus.instr_datas[0].patch.should eq 0
    my_wad.dmxgus.instr_datas[2].c_k.should eq 1
    my_wad.dmxgus.instr_datas[5].filename.gsub("\u0000", "").should eq "epiano2"
    my_wad.dmxgus.instr_datas[158].b_k.should eq 128
    my_wad.dmxgus.instr_datas[189].patch.should eq 215
    my_wad.dmxgus.instr_datas[50].d_k.should eq 50
    my_wad.dmxgus.instr_datas[72].a_k.should eq 73
  end
end
