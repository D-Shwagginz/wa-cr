module MapViewer
  VERSION =  1.0
  RESX    = 1000
  RESY    = 1000

  alias RL = Raylib
  alias RM = Raymath

  def self.run(input_wad : String, input_map : String = "")
    raise "ERROR: '#{input_wad}' IS NOT A VALID .wad FILE" unless File.exists?(input_wad)
    puts "\nNo map specified. Using first map in WAD\n\n" if input_map == ""

    wad = WAD.read(input_wad)
    palette = wad.playpal.palettes[0]
    if input_map == ""
      map = wad.maps.values[0]
    else
      raise "ERROR: '#{input_map}' IS NOT A VALID MAP IN '#{input_wad}'" if !(map = wad.maps[input_map]?)
    end

    RL.init_window(RESX, RESY, "Map Viewer")
    RL.set_window_state(RL::ConfigFlags::WindowResizable)
    RL.set_target_fps(60)

    textures = Hash(String, RL::Texture2D).new

    wad.sprites.each do |key, value|
      image = value.to_image(palette)
      textures[key] = RL.load_texture_from_image(image)
    end

    camera = RL::Camera2D.new
    camera.zoom = 0.2
    camera.target = RL::Vector2.new(x: map.vertexes[0].x_position, y: -map.vertexes[0].y_position)
    camera.offset = RL::Vector2.new(x: RL.get_screen_width/2, y: RL.get_screen_height/2)
    camera_speed = (0.1/camera.zoom)*100
    camera_zoom_speed = 0.008

    sectors : Array(Sector) = [] of Sector

    map.sectors.each.with_index do |sector, index|
      current_sector = Sector.new
      current_sector.index = index

      current_sector.image = wad.flats[sector.name_tex_floor.gsub("\u0000", "")].to_image(palette)
      textures[sector.name_tex_floor.gsub("\u0000", "")] = RL.load_texture_from_image(current_sector.image)

      map.linedefs.each do |linedef|
        if linedef.front_sidedef != -1
          front_sidedef = map.sidedefs[linedef.front_sidedef]
          if front_sidedef.facing_sector_num == index
            current_sector.points << RL::Vector2.new(
              x: map.vertexes[linedef.start_vertex].x_position,
              y: -map.vertexes[linedef.start_vertex].y_position
            )
            current_sector.points << RL::Vector2.new(
              x: map.vertexes[linedef.end_vertex].x_position,
              y: -map.vertexes[linedef.end_vertex].y_position
            )

            current_sector.texcoords << RL::Vector2.new(x: 0, y: 0)
            current_sector.texcoords << RL::Vector2.new(x: 0, y: 0)
          end
        end

        if linedef.back_sidedef != -1
          back_sidedef = map.sidedefs[linedef.back_sidedef]
          if back_sidedef.facing_sector_num == index
            current_sector.points << RL::Vector2.new(
              x: map.vertexes[linedef.start_vertex].x_position,
              y: -map.vertexes[linedef.start_vertex].y_position
            )
            current_sector.points << RL::Vector2.new(
              x: map.vertexes[linedef.end_vertex].x_position,
              y: -map.vertexes[linedef.end_vertex].y_position
            )

            current_sector.texcoords << RL::Vector2.new(x: 0, y: 0)
            current_sector.texcoords << RL::Vector2.new(x: 0, y: 0)
          end
        end
      end

      sectors << current_sector
    end

    until RL.close_window?
      if RL.key_down?(RL::KeyboardKey::Up)
        camera.target -= RL::Vector2.new(x: 0, y: camera_speed)
      end
      if RL.key_down?(RL::KeyboardKey::Down)
        camera.target += RL::Vector2.new(x: 0, y: camera_speed)
      end
      if RL.key_down?(RL::KeyboardKey::Left)
        camera.target -= RL::Vector2.new(x: camera_speed, y: 0)
      end
      if RL.key_down?(RL::KeyboardKey::Right)
        camera.target += RL::Vector2.new(x: camera_speed, y: 0)
      end
      if RL.key_down?(RL::KeyboardKey::Equal)
        camera.zoom += camera_zoom_speed
      end
      if RL.key_down?(RL::KeyboardKey::Minus)
        camera.zoom -= camera_zoom_speed
      end
      camera.zoom = camera.zoom.clamp(0.05, nil)
      camera_speed = (1/camera.zoom)*15

      # UPDATE START

      camera.offset = RL::Vector2.new(x: RL.get_screen_width/2, y: RL.get_screen_height/2)

      # UPDATE END

      RL.begin_drawing
      RL.clear_background(RL::RAYWHITE)
      RL.begin_mode_2d(camera)

      # DRAW START

      map.linedefs.each do |linedef|
        RL.draw_line(
          map.vertexes[linedef.start_vertex].x_position,
          -map.vertexes[linedef.start_vertex].y_position,
          map.vertexes[linedef.end_vertex].x_position,
          -map.vertexes[linedef.end_vertex].y_position,
          RL::BLACK
        )
      end

      # sectors.each do |sector|
      #   draw_texture_poly(
      #     loaded_textures[sector.index],
      #     sector.points,
      #     sector.texcoords,
      #     RL::WHITE
      #   )
      # end

      map.things.each do |thing|
        RL.draw_circle(
          thing.x_position,
          -thing.y_position,
          15,
          RL::RED
        )

        texture = textures[WAD::Map::THING_TYPES[thing.thing_type][1]]

        RL.draw_texture_ex(
          texture,
          RL::Vector2.new(
            x: thing.x_position - texture.width/4,
            y: -thing.y_position - texture.height/4
          ),
          0,
          0.5,
          RL::WHITE
        )
      end

      # DRAW END

      RL.end_mode_2d
      RL.end_drawing
    end

    textures.values.each do |texture|
      RL.unload_texture(texture)
    end

    RL.close_window
  end
end
