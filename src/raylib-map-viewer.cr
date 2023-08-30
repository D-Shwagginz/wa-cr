require "raylib-cr"
require "./raylib"
require "./wad-reader/**"
require "raylib-cr/rlgl"

module MapViewer
  VERSION = "0.1alpha"
  # Screen Resolution
  RESX = 800
  RESY = 450
  # Virtual Screen Resolution
  VRESX = 640
  VRESY = 360

  loaded_textures = [] of R::Texture

  def self.map_load_lines(name, wad)
    lines = [] of {R::Vector2, R::Vector2}
    if map = wad.maps.find { |m| m.name == name }
      map.linedefs.each do |linedef|
        start_vertex = R::Vector2.new
        end_vertex = R::Vector2.new
        start_vertex.x = map.vertexes[linedef.start_vertex].x_position
        start_vertex.y = map.vertexes[linedef.start_vertex].y_position
        end_vertex.x = map.vertexes[linedef.end_vertex].x_position
        end_vertex.y = map.vertexes[linedef.end_vertex].y_position
        lines << {start_vertex, end_vertex}
      end
    end
    return lines
  end

  # Runs the game.
  def self.run
    mywad = WAD.read("./rsrc/DOOM.WAD")
    palette = mywad.playpal.palettes[0]
    R.init_window(RESX, RESY, "Map Viewer")
    R.set_window_state(R::ConfigFlags::WindowResizable)
    R.set_target_fps(60)
    R.disable_cursor
    maplines = map_load_lines("E1M1", mywad)

    virtual_width_ratio = RESX.to_f/VRESX.to_f
    virtual_height_ratio = RESY.to_f/VRESY.to_f

    world_space_camera = R::Camera3D.new
    world_space_camera.position = R::Vector3.new x: maplines[0][0].x, y: 0, z: maplines[0][0].y
    world_space_camera.target = R::Vector3.new x: 0.0, y: 0.0, z: 0.0
    world_space_camera.up = R::Vector3.new x: 0.0, y: 1.0, z: 0.0
    world_space_camera.fovy = 90.0
    world_space_camera.projection = R::CameraProjection::Perspective

    R.update_camera(pointerof(world_space_camera), R::CameraMode::Free)

    screen_space_camera = R::Camera2D.new
    screen_space_camera.zoom = 1.0_f32

    target = R.load_render_texture(VRESX, VRESY)

    source_rec = R::Rectangle.new x: 0.0_f32, y: 0.0_f32, width: target.texture.width.to_f, height: -target.texture.height.to_f
    dest_rec = R::Rectangle.new x: 0, y: 0, width: R.get_screen_width, height: R.get_screen_height

    origin = R::Vector2.new(x: 0.0_f32, y: 0.0_f32)
    rotation = 0.0_f32
    camera_x = 0.0_f32
    camera_y = 0.0_f32

    until R.close_window?
      if R.window_resized? || R.window_maximized? || R.window_minimized?
        source_rec = R::Rectangle.new x: 0.0_f32, y: 0.0_f32, width: target.texture.width.to_f, height: -target.texture.height.to_f
        dest_rec = R::Rectangle.new x: 0, y: 0, width: R.get_screen_width, height: R.get_screen_height
      end

      # UPDATE
      RC.camera_yaw(pointerof(world_space_camera), ((-R.get_mouse_delta.x)/2)*Raylib.get_frame_time, false)
      RC.camera_pitch(pointerof(world_space_camera), ((-R.get_mouse_delta.y)/2)*Raylib.get_frame_time, true, false, false)
      if R.key_down?(R::KeyboardKey::W)
        RC.camera_move_forward(pointerof(world_space_camera), 40*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::S)
        RC.camera_move_forward(pointerof(world_space_camera), -40*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::D)
        RC.camera_move_right(pointerof(world_space_camera), 40*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::A)
        RC.camera_move_right(pointerof(world_space_camera), -40*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::E)
        RC.camera_move_up(pointerof(world_space_camera), 40*Raylib.get_frame_time)
      end
      if R.key_down?(R::KeyboardKey::Q)
        RC.camera_move_up(pointerof(world_space_camera), -40*Raylib.get_frame_time)
      end
      if R.key_down?(R::KeyboardKey::Up)
        RC.camera_pitch(pointerof(world_space_camera), 5*Raylib.get_frame_time, true, false, false)
      end
      if R.key_down?(R::KeyboardKey::Down)
        RC.camera_pitch(pointerof(world_space_camera), -5*Raylib.get_frame_time, true, false, false)
      end
      if R.key_down?(R::KeyboardKey::Right)
        RC.camera_yaw(pointerof(world_space_camera), -5*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::Left)
        RC.camera_yaw(pointerof(world_space_camera), 5*Raylib.get_frame_time, false)
      end

      R.begin_drawing
      R.begin_texture_mode(target)
      R.clear_background(R::RAYWHITE)
      R.begin_mode_3d(world_space_camera)

      # DRAW
      maplines.each do |line|
        R.draw_line_3d(R::Vector3.new(x: -line[0].x, y: 0, z: line[0].y), R::Vector3.new(x: -line[1].x, y: 0, z: line[1].y), R::BLACK)
      end

      R.end_mode_3d
      R.end_texture_mode
      R.end_drawing

      R.begin_drawing
      R.clear_background(R::RED)
      R.begin_mode_2d(screen_space_camera)
      R.draw_texture_pro(target.texture, source_rec, dest_rec, origin, 0.0_f32, R::WHITE)
      R.end_mode_2d
      R.end_drawing
    end
    R.close_window
  end
end

# Draws a texture in 3D space with pro parameters
def self.draw_texture_pro_3d(texture : Raylib::Texture2D, sourceRec : Raylib::Rectangle, destRec : Raylib::Rectangle, origin : Raylib::Vector3, rotation : Float, posZ : Float, tint : Raylib::Color)
  if texture.id > 0
    width = texture.width
    height = texture.height

    flipX = false

    if sourceRec.width < 0
      flipX = true
      sourceRec.width *= -1
    end

    if sourceRec.height < 0
      sourceRec.y -= sourceRec.height
    end

    RLGL.enable_texture(texture.id)
    RLGL.push_matrix()
    RLGL.translate_f(destRec.x, destRec.y, 0)
    RLGL.rotate_f(rotation, 0.0, 0.0, 1.0)
    RLGL.begin(RLGL::QUADS)
    RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)
    # Normal vector pointing towards viewer
    RLGL.normal_3f(0.0, 0.0, 1.0)
    # Bottom-left corner for texture and quad
    if flipX
      RLGL.texcoord_2f((sourceRec.x + sourceRec.width)/width, sourceRec.y/height)
    else
      RLGL.texcoord_2f(sourceRec.x/width, sourceRec.y/height)
    end
    RLGL.vertex_3f(0.0, 0.0, posZ)

    # Bottom-right corner for texture and quad
    if flipX
      RLGL.texcoord_2f((sourceRec.x + sourceRec.width)/width, (sourceRec.y + sourceRec.height)/height)
    else
      RLGL.texcoord_2f(sourceRec.x/width, (sourceRec.y + sourceRec.height)/height)
    end
    RLGL.vertex_3f(0.0, destRec.height, posZ)

    # Top-right corner for texture and quad
    if flipX
      RLGL.texcoord_2f(sourceRec.x/width, (sourceRec.y + sourceRec.height)/height)
    else
      RLGL.texcoord_2f((sourceRec.x + sourceRec.width)/width, (sourceRec.y + sourceRec.height)/height)
    end
    RLGL.vertex_3f(destRec.width, destRec.height, posZ)

    # Top-left corner for texture and quad
    if flipX
      RLGL.texcoord_2f(sourceRec.x/width, sourceRec.y/height)
    else
      RLGL.texcoord_2f((sourceRec.x + sourceRec.width)/width, (sourceRec.y + sourceRec.height)/height)
    end
    RLGL.vertex_3f(destRec.width, 0.0, posZ)
    RLGL.end
    RLGL.pop_matrix
    RLGL.disable_texture
  end
end

MapViewer.run