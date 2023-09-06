require "../../spec_helper"

describe WAD::Map::Vertex, tags: "map" do
  it "should properly set map vertexes", tags: "vertexes" do
    my_wad = WAD.read("./rsrc/DOOM.WAD")

    vertex_check(my_wad, "E1M1", 126, 1664, -2432)
    vertex_check(my_wad, "E1M2", 757, -392, 2320)
    vertex_check(my_wad, "E1M6", 366, 2880, -1888)
    vertex_check(my_wad, "E2M1", 370, 192, 128)
    vertex_check(my_wad, "E3M1", 45, -192, -96)
    vertex_check(my_wad, "E3M9", 47, 0, -0)
  end
end
