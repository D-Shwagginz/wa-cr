require "../../spec_helper"

describe WAD::Map::Vertexes, tags: "map" do
  it "should properly set map vertexes", tags: ["vertex", "v"] do
    mywad = WAD.read("./rsrc/DOOM.WAD")

    vertex_check(mywad, map_name: "E1M1", vertex_index: 126, x_pos: 1664, y_pos: -2432)
    vertex_check(mywad, map_name: "E1M2", vertex_index: 757, x_pos: -392, y_pos: 2320)

    mywad.maps["E1M7"].vertexes[695].x_position.should eq 1664
    mywad.maps["E2M8"].vertexes[78].y_position.should eq -224
    mywad.maps["E3M5"].vertexes[1198].x_position.should eq -16
    mywad.maps["E1M3"].vertexes[382].y_position.should eq -2304
    mywad.maps["E3M2"].vertexes[0].x_position.should eq 1984
  end
end
