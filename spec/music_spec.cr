require "./spec_helper"

describe WAD::Music do
  it "should properly read music file" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.music.find! { |m| m.name == "D_E1M5" }.identifier.should eq "MUS\u001A"
    mywad.music.find! { |m| m.name == "D_E3M2" }.identifier.should eq "MUS\u001A"
    mywad.music.find! { |m| m.name == "D_E2M8" }.score_len.should eq 45988
    mywad.music.find! { |m| m.name == "D_BUNNY" }.score_start.should eq 50
    mywad.music.find! { |m| m.name == "D_E2M1" }.channels.should eq 6
  end
end