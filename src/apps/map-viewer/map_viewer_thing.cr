module Apps
  module MapViewer
    # :nodoc:
    class Thing
      property thing : WAD::Map::Thing = WAD::Map::Thing.new
      property index : Int32 = 0
      property texture : RL::Texture2D? = RL::Texture2D.new
      property mouse_over : Bool = false

      def initialize(@thing, @index)
      end

      def draw
        RL.draw_circle(
          thing.x_position,
          -thing.y_position,
          WAD::Map::THING_TYPES[thing.thing_type][2],
          RL::Color.new(r: 255, g: 0, b: 0, a: 60)
        )

        if texture
          RL.draw_texture_ex(
            texture.as(RL::Texture2D),
            RL::Vector2.new(
              x: thing.x_position - texture.as(RL::Texture2D).width*WAD::Map::THING_TYPES[thing.thing_type][2]/3/10/2,
              y: -thing.y_position - texture.as(RL::Texture2D).height*WAD::Map::THING_TYPES[thing.thing_type][2]/3/10/2
            ),
            0,
            (WAD::Map::THING_TYPES[thing.thing_type][2]/3)/10,
            RL::WHITE
          )
        end
      end

      def update
        if @mouse_over
          RL.draw_text(
            WAD::Map::THING_TYPES[thing.thing_type][0],
            RL.get_mouse_x + 15,
            RL.get_mouse_y - 15,
            25,
            RL::BLUE
          )
        end
      end
    end
  end
end
