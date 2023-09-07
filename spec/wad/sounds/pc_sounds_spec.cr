require "../../spec_helper"

describe WAD::PcSound, tags: "sounds" do
  it "should properly set pc sounds", tags: "pcsounds" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.pcsounds["DPSAWIDL"].samples[3].should eq 63
    my_wad.pcsounds["DPDOROPN"].samples[23].should eq 24
    my_wad.pcsounds["DPSTNMOV"].format_num.should eq 0
    my_wad.pcsounds["DPSWTCHX"].samples_num.should eq 8
    my_wad.pcsounds["DPSLOP"].samples[19].should eq 12
  end
end
