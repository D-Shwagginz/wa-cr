module Apps
  module MapViewer
    VERSION = "1.0.0"
    RESX    = 1000
    RESY    = 1000

    # :nodoc:
    alias RL = Raylib
    # :nodoc:
    alias RM = Raymath

    # Runs the map viewer given a wad path and a map name
    def self.run(input_file : String, input_map : String = "")
      raise "ERROR: '#{input_file}' IS NOT A VALID .wad FILE" unless File.exists?(input_file)
      wad = WAD.read(input_file)
      self.run(wad, input_map)
    end

    # Runs the map viewer given a wad and a map name
    def self.run(wad : WAD, input_map : String = "")
      puts "\nNo map specified. Using first map in WAD\n\n" if input_map == ""

      palette = wad.playpal.palettes[0]

      if input_map == ""
        map = wad.maps.values[0]
      else
        raise "ERROR: '#{input_map}' IS NOT A VALID MAP IN '#{wad}'" if !(map = wad.maps[input_map]?)
      end

      RL.init_window(RESX, RESY, "Map Viewer")
      RL.set_window_state(RL::ConfigFlags::WindowResizable)
      RL.set_target_fps(60)

      textures = Hash(String, RL::Texture2D).new

      wad.sprites.each do |key, value|
        image = value.to_image(palette)
        textures[key] = RL.load_texture_from_image(image)
      end

      wad.flats.each do |key, value|
        image = value.to_image(palette)
        textures[key] = RL.load_texture_from_image(image)
      end

      camera = RL::Camera2D.new
      camera.zoom = 1.0
      camera.target = RL::Vector2.new(x: map.vertexes[0].x_position, y: -map.vertexes[0].y_position)
      camera.offset = RL::Vector2.new(x: RL.get_screen_width/2, y: RL.get_screen_height/2)
      camera_speed_multiplier = 600
      camera_zoom_speed = 0.6
      camera_speed = 0

      grid_size_exponent = 4
      grid_size = 2**grid_size_exponent

      sectors : Array(Sector) = [] of Sector

      map.sectors.each.with_index do |sector, index|
        current_sector = Sector.new
        current_sector.index = index

        current_sector.sector = sector

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

      things : Array(Thing) = [] of Thing

      map.things.each.with_index do |thing, index|
        current_thing = Thing.new(thing, index)
        current_thing.texture = textures[WAD::Map::THING_TYPES[thing.thing_type][1]]?
        things << current_thing
      end

      until RL.close_window?
        if RL.key_down?(RL::KeyboardKey::Up)
          camera.target -= RL::Vector2.new(x: 0, y: camera_speed*RL.get_frame_time)
        end
        if RL.key_down?(RL::KeyboardKey::Down)
          camera.target += RL::Vector2.new(x: 0, y: camera_speed*RL.get_frame_time)
        end
        if RL.key_down?(RL::KeyboardKey::Left)
          camera.target -= RL::Vector2.new(x: camera_speed*RL.get_frame_time, y: 0)
        end
        if RL.key_down?(RL::KeyboardKey::Right)
          camera.target += RL::Vector2.new(x: camera_speed*RL.get_frame_time, y: 0)
        end

        if RL.key_pressed?(RL::KeyboardKey::LeftBracket)
          grid_size_exponent -= 1
          grid_size_exponent = grid_size_exponent.clamp(0, 10)
          puts "Grid Size: #{grid_size_exponent}"
        end
        if RL.key_pressed?(RL::KeyboardKey::RightBracket)
          grid_size_exponent += 1
          grid_size_exponent = grid_size_exponent.clamp(0, 10)
          puts "Grid Size: #{grid_size_exponent}"
        end
        grid_size = 2**grid_size_exponent

        if RL.key_down?(RL::KeyboardKey::Equal)
          camera.zoom += camera_zoom_speed*RL.get_frame_time
        end
        if RL.key_down?(RL::KeyboardKey::Minus)
          camera.zoom -= camera_zoom_speed*RL.get_frame_time
        end
        camera.zoom = camera.zoom.clamp(0.05, nil)
        camera_speed = (1/camera.zoom)*camera_speed_multiplier

        # UPDATE START

        camera.offset = RL::Vector2.new(x: RL.get_screen_width/2, y: RL.get_screen_height/2)

        things.each do |thing|
          thing.mouse_over = RL.check_collision_point_circle?(
            RL.get_screen_to_world_2d(
              RL::Vector2.new(x: RL.get_mouse_x, y: RL.get_mouse_y),
              camera
            ),
            RL::Vector2.new(
              x: map.things[thing.index].x_position,
              y: -map.things[thing.index].y_position
            ),
            WAD::Map::THING_TYPES[map.things[thing.index].thing_type][2]
          )
          thing.update
        end

        # UPDATE END

        RL.begin_drawing
        RL.clear_background(RL::RAYWHITE)

        # UI DRAW START

        RL.draw_text(
          "Grid Size: #{grid_size_exponent}", 10, 10, 50, RL::RED)

        RL.draw_text(
          "Zoom: #{camera.zoom}", 10, 60, 50, RL::RED)

        RL.draw_text(
          "Cursor X: #{RL.get_screen_to_world_2d(RL::Vector2.new(x: RL.get_mouse_x, y: RL.get_mouse_y), camera).x}",
          10,
          110,
          50,
          RL::RED
        )
        RL.draw_text(
          "Cursor y: #{-RL.get_screen_to_world_2d(RL::Vector2.new(x: RL.get_mouse_x, y: RL.get_mouse_y), camera).y}",
          10,
          160,
          50,
          RL::RED
        )
        # UI DRAW END

        RL.begin_mode_2d(camera)

        # DRAW START

        draw_grid(grid_size)

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
        #     textures[sector.sector.name_tex_floor.gsub("\u0000", "")],
        #     sector.points,
        #     sector.texcoords,
        #     RL::WHITE
        #   )
        # end

        things.each { |thing| thing.draw }

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
end
