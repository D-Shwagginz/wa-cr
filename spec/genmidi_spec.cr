require "./spec_helper"

describe WAD::Genmidi do
  it "should properly set the genmidi" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.genmidi.header.gsub("\u0000", "").should eq "#OPL_II#"
    mywad.genmidi.instr_datas[0].header[0].should eq 0
    mywad.genmidi.instr_datas[27].voice1_data[2].should eq 50
    mywad.genmidi.instr_datas[172].voice2_data[-1].should eq 0
  end
end
