require "../../spec_helper"

describe WAD::Sound, tags: "sounds" do
  it "should properly set sounds", tags: "sound" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.sounds["DSSHOTGN"].format_num.should eq 3
    mywad.sounds["DSSAWIDL"].sample_rate.should eq 11025
    mywad.sounds["DSRLAUNC"].samples_num.should eq 15483
    mywad.sounds["DSSWTCHX"].samples[0].should eq 126
    mywad.sounds["DSSLOP"].samples[0].should eq 126
    mywad.sounds["DSSLOP"].samples[1].should eq 125
    mywad.sounds["DSSLOP"].samples[2].should eq 125
    mywad.sounds["DSSLOP"].samples[3].should eq 127
    mywad.sounds["DSSLOP"].samples[4].should eq 128
    mywad.sounds["DSSLOP"].samples[11].should eq 129
    mywad.sounds["DSSLOP"].samples[-1].should eq 125
    mywad.sounds["DSSLOP"].samples[-2].should eq 129
    mywad.sounds["DSSLOP"].samples[-3].should eq 128
    mywad.sounds["DSSLOP"].samples[-4].should eq 128
    mywad.sounds["DSPLPAIN"].samples[0].should eq 125
    mywad.sounds["DSPLPAIN"].samples[1].should eq 125
    mywad.sounds["DSPLPAIN"].samples[2].should eq 125
    mywad.sounds["DSPLPAIN"].samples[3].should eq 125
    mywad.sounds["DSPLPAIN"].samples[-1].should eq 125
    mywad.sounds["DSPLPAIN"].samples[-2].should eq 122
    mywad.sounds["DSPLPAIN"].samples[-3].should eq 125
    mywad.sounds["DSPLPAIN"].samples[-4].should eq 125
    mywad.sounds["DSPDIEHI"].samples[0].should eq 126
    mywad.sounds["DSPDIEHI"].samples[1].should eq 126
    mywad.sounds["DSPDIEHI"].samples[2].should eq 126
    mywad.sounds["DSPDIEHI"].samples[3].should eq 126
    mywad.sounds["DSPDIEHI"].samples[-1].should eq 126
    mywad.sounds["DSPDIEHI"].samples[-2].should eq 125
    mywad.sounds["DSPDIEHI"].samples[-3].should eq 124
    mywad.sounds["DSPDIEHI"].samples[-4].should eq 124
  end
end
