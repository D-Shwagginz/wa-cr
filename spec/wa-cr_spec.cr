require "./spec_helper"

describe WAD do
  it "should properly set the wad type" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")
    (my_wad.type == WAD::Type::Internal).should be_true
  end
end
