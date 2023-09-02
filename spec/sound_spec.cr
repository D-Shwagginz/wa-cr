require "./spec_helper"

describe WAD::Sound do
  it "should properly create sound file" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    File.open("./rsrc/spectest.wav", "w+") do |io|
      mywad.sounds["DSPISTOL"].to_wav(io)
    end
    File.exists?("./rsrc/spectest.wav").should be_true
    File.delete("./rsrc/spectest.wav")
  end
end
