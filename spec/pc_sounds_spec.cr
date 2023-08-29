require "./spec_helper"

describe WAD::PcSound do
  it "should properly set pc sounds" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.pcsounds.find! { |m| m.name == "DPSAWIDL" }.samples[3].should eq 63
    mywad.pcsounds.find! { |m| m.name == "DPDOROPN" }.samples[23].should eq 24
    mywad.pcsounds.find! { |m| m.name == "DPSTNMOV" }.format_num.should eq 0
    mywad.pcsounds.find! { |m| m.name == "DPSWTCHX" }.samples_num.should eq 8
    mywad.pcsounds.find! { |m| m.name == "DPSLOP" }.samples[19].should eq 12
  end
end
