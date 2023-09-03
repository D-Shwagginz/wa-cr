require "../../spec_helper"

describe WAD::PcSound, tags: "sounds" do
  it "should properly set pc sounds", tags: "pcsounds" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.pcsounds["DPSAWIDL"].samples[3].should eq 63
    mywad.pcsounds["DPDOROPN"].samples[23].should eq 24
    mywad.pcsounds["DPSTNMOV"].format_num.should eq 0
    mywad.pcsounds["DPSWTCHX"].samples_num.should eq 8
    mywad.pcsounds["DPSLOP"].samples[19].should eq 12
  end
end
