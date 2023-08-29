require "./spec_helper"

describe WAD do
  it "should properly set the wad type" do
    mywad = WAD.read("./rsrc/DOOM.WAD")
    (mywad.type == WAD::Type::Internal).should be_true
  end
end
