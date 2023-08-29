require "./spec_helper"

describe WAD::Sound do
  it "should properly set sounds" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.sounds.find! { |m| m.name == "DSSHOTGN" }.format_num.should eq 3
    mywad.sounds.find! { |m| m.name == "DSSAWIDL" }.sample_rate.should eq 11025
    mywad.sounds.find! { |m| m.name == "DSRLAUNC" }.samples_num.should eq 15483
    mywad.sounds.find! { |m| m.name == "DSSWTCHX" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[3].should eq 127
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[4].should eq 128
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[11].should eq 129
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-2].should eq 129
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-3].should eq 128
    mywad.sounds.find! { |m| m.name == "DSSLOP" }.samples[-4].should eq 128
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[0].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[3].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-1].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-2].should eq 122
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-3].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPLPAIN" }.samples[-4].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[0].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[1].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[2].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[3].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-1].should eq 126
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-2].should eq 125
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-3].should eq 124
    mywad.sounds.find! { |m| m.name == "DSPDIEHI" }.samples[-4].should eq 124
  end
end
