require "../../spec_helper"

describe WAD::Music, tags: "sounds" do
  it "should properly read music file", tags: "music" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.music["D_E1M5"].identifier.should eq "MUS\u001A"
    mywad.music["D_E3M2"].identifier.should eq "MUS\u001A"
    mywad.music["D_E2M8"].score_len.should eq 45988
    mywad.music["D_BUNNY"].score_start.should eq 50
    mywad.music["D_E2M1"].channels.should eq 6
  end
end
