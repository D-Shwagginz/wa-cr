require "../../spec_helper"

describe WAD::Sound, tags: "sounds" do
  it "should properly set sounds", tags: "sound" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.sounds["DSSHOTGN"].format_num.should eq 3
    my_wad.sounds["DSSAWIDL"].sample_rate.should eq 11025
    my_wad.sounds["DSRLAUNC"].samples_num.should eq 15483
    my_wad.sounds["DSSWTCHX"].samples[0].should eq 126
    my_wad.sounds["DSSLOP"].samples[0].should eq 126
    my_wad.sounds["DSSLOP"].samples[1].should eq 125
    my_wad.sounds["DSSLOP"].samples[2].should eq 125
    my_wad.sounds["DSSLOP"].samples[3].should eq 127
    my_wad.sounds["DSSLOP"].samples[4].should eq 128
    my_wad.sounds["DSSLOP"].samples[11].should eq 129
    my_wad.sounds["DSSLOP"].samples[-1].should eq 125
    my_wad.sounds["DSSLOP"].samples[-2].should eq 129
    my_wad.sounds["DSSLOP"].samples[-3].should eq 128
    my_wad.sounds["DSSLOP"].samples[-4].should eq 128
    my_wad.sounds["DSPLPAIN"].samples[0].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[1].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[2].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[3].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[-1].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[-2].should eq 122
    my_wad.sounds["DSPLPAIN"].samples[-3].should eq 125
    my_wad.sounds["DSPLPAIN"].samples[-4].should eq 125
    my_wad.sounds["DSPDIEHI"].samples[0].should eq 126
    my_wad.sounds["DSPDIEHI"].samples[1].should eq 126
    my_wad.sounds["DSPDIEHI"].samples[2].should eq 126
    my_wad.sounds["DSPDIEHI"].samples[3].should eq 126
    my_wad.sounds["DSPDIEHI"].samples[-1].should eq 126
    my_wad.sounds["DSPDIEHI"].samples[-2].should eq 125
    my_wad.sounds["DSPDIEHI"].samples[-3].should eq 124
    my_wad.sounds["DSPDIEHI"].samples[-4].should eq 124
  end
end
