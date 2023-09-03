require "spec"
require "../src/wa-cr"

def vertex_check(mywad : WAD, map_name : String, vertex_index : Int, x_pos : Int, y_pos : Int)
  mywad.maps[map_name].vertexes[vertex_index].x_position.should eq x_pos
  mywad.maps[map_name].vertexes[vertex_index].y_position.should eq y_pos
end
