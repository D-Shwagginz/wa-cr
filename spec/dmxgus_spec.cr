require "./spec_helper"

describe WAD::Dmxgus do
  it "should properly set the dmxgus" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.dmxgus.instr_datas[0].patch.should eq 0
    mywad.dmxgus.instr_datas[2].c_k.should eq 1
    mywad.dmxgus.instr_datas[5].filename.gsub("\u0000", "").should eq "epiano2"
    mywad.dmxgus.instr_datas[158].b_k.should eq 128
    mywad.dmxgus.instr_datas[189].patch.should eq 215
    mywad.dmxgus.instr_datas[50].d_k.should eq 50
    mywad.dmxgus.instr_datas[72].a_k.should eq 73
  end
end
