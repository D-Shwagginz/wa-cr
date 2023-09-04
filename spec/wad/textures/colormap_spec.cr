require "../../spec_helper"

describe WAD::Colormap, tags: "textures" do
  it "should properly set the colormap", tags: "colormap" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    my_wad.colormap.tables[0].table[0].should eq 0
    my_wad.colormap.tables[0].table[208].should eq 4
    my_wad.colormap.tables[0].table[255].should eq 255
    my_wad.colormap.tables[1].table[88].should eq 89
    my_wad.colormap.tables[2].table[3].should eq 105
    my_wad.colormap.tables[33].table[255].should eq 0
    my_wad.colormap.tables[33].table[255].should eq 0
  end
end
