require "raylib-cr/rlgl"

module MapViewer
  class Sector
    property texcoords : Array(RL::Vector2) = [] of RL::Vector2
    property points : Array(RL::Vector2) = [] of RL::Vector2
    property image : RL::Image = RL::Image.new
    property index : Int32 = 0
  end

  def self.draw_texture_poly(texture : RL::Texture2D, points : Array(RL::Vector2), texcoords : Array(RL::Vector2), tint : RL::Color)
    sum_x = 0
    sum_y = 0
    points.each { |vector| sum_x += vector.x }
    points.each { |vector| sum_y += vector.y }
    center = RL::Vector2.new(x: sum_x/points.size, y: sum_y/points.size)

    points_count = points.size

    RLGL.set_texture(texture.id)

    RLGL.begin(RLGL::QUADS)

    RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)

    (points_count - 1).times do |i|
      RLGL.texcoord_2f(0.5, 0.5)
      RLGL.vertex_2f(center.x, center.y)

      RLGL.texcoord_2f(texcoords[i].x, texcoords[i].y)
      RLGL.vertex_2f(points[i].x, points[i].y)

      RLGL.texcoord_2f(texcoords[i + 1].x, texcoords[i + 1].y)
      RLGL.vertex_2f(points[i + 1].x, points[i + 1].y)

      RLGL.texcoord_2f(texcoords[i + 1].x, texcoords[i + 1].y)
      RLGL.vertex_2f(points[i + 1].x, points[i + 1].y)
    end

    RLGL.end
    RLGL.set_texture(0)
  end
end
