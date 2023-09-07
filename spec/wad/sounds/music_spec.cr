require "../../spec_helper"

describe WAD::Music, tags: "sounds" do
  it "should properly read music file", tags: "music" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.music["D_E1M5"].identifier.should eq "MUS\u001A"
    my_wad.music["D_E3M2"].identifier.should eq "MUS\u001A"
    my_wad.music["D_E2M8"].score_len.should eq 45988
    my_wad.music["D_BUNNY"].score_start.should eq 50
    my_wad.music["D_E2M1"].channels.should eq 6
  end
end
