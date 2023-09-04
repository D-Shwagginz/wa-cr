require "../../spec_helper"

describe WAD::Genmidi, tags: "sounds" do
  it "should properly set the genmidi", tags: "genmidi" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.genmidi.header.gsub("\u0000", "").should eq "#OPL_II#"
    my_wad.genmidi.instr_datas[0].header[0].should eq 0
    my_wad.genmidi.instr_datas[27].voice1_data[2].should eq 50
    my_wad.genmidi.instr_datas[172].voice2_data[-1].should eq 0
  end
end
