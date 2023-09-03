require "spec"
require "../src/wa-cr"

macro def_check(name, parameters, content)
  def {{name}}(wad : WAD, map_name : String, index : Int{% for value in parameters %} ,{{value}}{% end %})
    {% for value in content %}
      {{value}}
    {% end %}
  end
end

macro map_check(what_is, thing_to_check, should_eq)
  wad.maps[map_name].{{what_is}}[index].{{thing_to_check}}.should eq {{should_eq}}
end

def_check(
  thing_check,
  [x_pos : Int, y_pos : Int, angle : Int, type : Int, flags : Int],
  [
    map_check(things, x_position, x_pos),
    map_check(things, y_position, y_pos),
    map_check(things, angle_facing, angle),
    map_check(things, thing_type, type),
    map_check(things, flags, flags),
  ]
)

def_check(
  linedef_check,
  [start_vertex : Int, end_vertex : Int, flags : Int, type : Int, tag : Int, front : Int, back : Int],
  [
    map_check(linedefs, start_vertex, start_vertex),
    map_check(linedefs, end_vertex, end_vertex),
    map_check(linedefs, flags, flags),
    map_check(linedefs, special_type, type),
    map_check(linedefs, sector_tag, tag),
    map_check(linedefs, front_sidedef, front),
    map_check(linedefs, back_sidedef, back),
  ]
)

def_check(
  sidedef_check,
  [x_offset : Int, y_offset : Int, up : String, low : String, mid : String, sector : Int],
  [
    map_check(sidedefs, x_offset, x_offset),
    map_check(sidedefs, y_offset, y_offset),
    map_check(sidedefs, name_tex_up.gsub("\u0000", ""), up),
    map_check(sidedefs, name_tex_low.gsub("\u0000", ""), low),
    map_check(sidedefs, name_tex_mid.gsub("\u0000", ""), mid),
    map_check(sidedefs, facing_sector_num, sector),
  ]
)

def_check(
  vertex_check,
  [x_pos : Int, y_pos : Int],
  [
    map_check(vertexes, x_position, x_pos),
    map_check(vertexes, y_position, y_pos),
  ]
)

def_check(
  seg_check,
  [start_vertex : Int, end_vertex : Int, angle : Int, linedef : Int, direction : Int, offset : Int],
  [
    map_check(segs, start_vertex_num, start_vertex),
    map_check(segs, end_vertex_num, end_vertex),
    map_check(segs, angle, angle),
    map_check(segs, linedef_num, linedef),
    map_check(segs, direction, direction),
    map_check(segs, offset, offset),
  ]
)

def_check(
  ssector_check,
  [seg_count : Int, first_seg : Int],
  [
    map_check(ssectors, seg_count, seg_count),
    map_check(ssectors, first_seg_num, first_seg),
  ]
)

def_check(
  node_check,
  [x_coord : Int, y_coord : Int, x_change : Int, y_change : Int],
  [
    map_check(nodes, x_coord, x_coord),
    map_check(nodes, y_coord, y_coord),
    map_check(nodes, x_change_to_end, x_change),
    map_check(nodes, y_change_to_end, y_change)
  ]
)

def_check(
  sector_check,
  [floor_height : Int, ceiling_height : Int, floor : String, ceiling : String, light : Int, type : Int, tag : Int],
  [
    map_check(sectors, floor_height, floor_height),
    map_check(sectors, ceiling_height, ceiling_height),
    map_check(sectors, name_tex_floor.gsub("\u0000", ""), floor),
    map_check(sectors, name_tex_ceiling.gsub("\u0000", ""), ceiling),
    map_check(sectors, light_level, light),
    map_check(sectors, special_type, type),
    map_check(sectors, tag_num, tag)
  ]
)