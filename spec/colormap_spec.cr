require "./spec_helper"

describe WAD::Colormap do
  it "should properly set the colormap" do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    mywad.colormap.tables[0].table[0].should eq 0
    mywad.colormap.tables[0].table[208].should eq 4
    mywad.colormap.tables[0].table[255].should eq 255
    mywad.colormap.tables[1].table[88].should eq 89
    mywad.colormap.tables[2].table[3].should eq 105
    mywad.colormap.tables[33].table[255].should eq 0
    mywad.colormap.tables[33].table[255].should eq 0
  end
end
