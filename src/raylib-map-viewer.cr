require "raylib-cr"
require "./raylib"
require "./wad-reader/**"
require "raylib-cr/rlgl"

class Texture
  property name : String = ""
  property texture : R::Texture = R::Texture.new
  property offset : R::Vector2 = R::Vector2.new
  property size : R::Vector2 = R::Vector2.new

  def initialize(@name : String, @texture : R::Texture, @offset : R::Vector2, @size : R::Vector2)
  end
end

module MapViewer
  VERSION = "0.1alpha"
  # Screen Resolution
  RESX = 1280
  RESY =  720
  # Virtual Screen Resolution
  VRESX = 1280
  VRESY =  720

  MOVEMENT_SPEED = 1000
  WAD_LOCATION   = "./rsrc/DOOM.WAD"
  MAP_NAME       = "E1M1"

  # Runs the game.
  def self.run
    mywad = WAD.read(WAD_LOCATION)
    palette = mywad.playpal.palettes[0]
    loaded_textures = [] of Texture

    if map = mywad.maps[MAP_NAME]
    else
      raise "#{MAP_NAME} is not a map in #{mywad}"
    end

    R.init_window(RESX, RESY, "Map Viewer")
    R.set_window_state(R::ConfigFlags::WindowResizable)
    R.set_target_fps(60)
    R.disable_cursor

    # Get all used textures
    map.linedefs.each do |linedef|
      front_sidedef = map.sidedefs[linedef.front_sidedef]

      if front_sidedef.name_tex_up != "" && !loaded_textures.any? { |m| m.name == front_sidedef.name_tex_up }
        image = mywad.get_texture(front_sidedef.name_tex_up, palette)
        loaded_textures << Texture.new(
          front_sidedef.name_tex_up,
          R.load_texture_from_image(image),
          R::Vector2.new(x: front_sidedef.x_offset, y: front_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end

      if front_sidedef.name_tex_low != "" && !loaded_textures.any? { |m| m.name == front_sidedef.name_tex_low }
        image = mywad.get_texture(front_sidedef.name_tex_low, palette)
        loaded_textures << Texture.new(
          front_sidedef.name_tex_low,
          R.load_texture_from_image(image),
          R::Vector2.new(x: front_sidedef.x_offset, y: front_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end

      if front_sidedef.name_tex_mid != "" && !loaded_textures.any? { |m| m.name == front_sidedef.name_tex_mid }
        image = mywad.get_texture(front_sidedef.name_tex_mid, palette)
        loaded_textures << Texture.new(
          front_sidedef.name_tex_mid,
          R.load_texture_from_image(image),
          R::Vector2.new(x: front_sidedef.x_offset, y: front_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end

      back_sidedef = map.sidedefs[linedef.back_sidedef]

      if back_sidedef.name_tex_up != "" && !loaded_textures.any? { |m| m.name == back_sidedef.name_tex_up }
        image = mywad.get_texture(back_sidedef.name_tex_up, palette)
        loaded_textures << Texture.new(
          back_sidedef.name_tex_up,
          R.load_texture_from_image(image),
          R::Vector2.new(x: back_sidedef.x_offset, y: back_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end

      if back_sidedef.name_tex_low != "" && !loaded_textures.any? { |m| m.name == back_sidedef.name_tex_low }
        image = mywad.get_texture(back_sidedef.name_tex_low, palette)
        loaded_textures << Texture.new(
          back_sidedef.name_tex_low,
          R.load_texture_from_image(image),
          R::Vector2.new(x: back_sidedef.x_offset, y: back_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end

      if back_sidedef.name_tex_mid != "" && !loaded_textures.any? { |m| m.name == back_sidedef.name_tex_mid }
        image = mywad.get_texture(back_sidedef.name_tex_mid, palette)
        loaded_textures << Texture.new(
          back_sidedef.name_tex_mid,
          R.load_texture_from_image(image),
          R::Vector2.new(x: back_sidedef.x_offset, y: back_sidedef.y_offset),
          (R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.end_vertex].y_position) -
           R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
        )
      end
    end

    virtual_width_ratio = RESX.to_f/VRESX.to_f
    virtual_height_ratio = RESY.to_f/VRESY.to_f

    world_space_camera = R::Camera3D.new
    world_space_camera.position = R::Vector3.new x: map.vertexes[map.linedefs[0].start_vertex].x_position, y: 0, z: -map.vertexes[map.linedefs[0].start_vertex].y_position
    # world_space_camera.position = R::Vector3.new x: 0.0, y: 10.0, z: 10.0
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
      RC.camera_yaw(pointerof(world_space_camera), ((-R.get_mouse_delta.x)/10)*Raylib.get_frame_time, false)
      RC.camera_pitch(pointerof(world_space_camera), ((-R.get_mouse_delta.y)/10)*Raylib.get_frame_time, true, false, false)
      if R.key_down?(R::KeyboardKey::W)
        RC.camera_move_forward(pointerof(world_space_camera), MOVEMENT_SPEED*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::S)
        RC.camera_move_forward(pointerof(world_space_camera), -MOVEMENT_SPEED*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::D)
        RC.camera_move_right(pointerof(world_space_camera), MOVEMENT_SPEED*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::A)
        RC.camera_move_right(pointerof(world_space_camera), -MOVEMENT_SPEED*Raylib.get_frame_time, false)
      end
      if R.key_down?(R::KeyboardKey::E)
        RC.camera_move_up(pointerof(world_space_camera), MOVEMENT_SPEED*Raylib.get_frame_time)
      end
      if R.key_down?(R::KeyboardKey::Q)
        RC.camera_move_up(pointerof(world_space_camera), -MOVEMENT_SPEED*Raylib.get_frame_time)
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

      R.draw_cube((R::Vector3.new x: map.vertexes[map.linedefs[0].start_vertex].x_position, y: 0, z: -map.vertexes[map.linedefs[0].start_vertex].y_position), 2.0, 2.0, 2.0, R::RED)

      map.linedefs.each do |linedef|
        if front_middle_tex = loaded_textures.find { |m| m.name == map.sidedefs[linedef.front_sidedef].name_tex_mid }
          draw_texture_pro_3d(
            front_middle_tex.texture,
            R::Rectangle.new(x: front_middle_tex.offset.x, y: front_middle_tex.offset.y, width: front_middle_tex.texture.width, height: front_middle_tex.texture.height),
            R::Rectangle.new(x: 0, y: 0, width: front_middle_tex.texture.width, height: front_middle_tex.texture.height),
            rotation: 180.0,
            origin: R::Vector3.new(x: map.vertexes[linedef.start_vertex].x_position, y: 0, z: map.vertexes[linedef.start_vertex].y_position),
            # TODO: Fix not getting right rotation
            z_rotate: RM.vector2_line_angle(
              RM.vector2_normalize(R::Vector2.new(x: map.vertexes[linedef.start_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position)),
              RM.vector2_normalize(R::Vector2.new(x: map.vertexes[linedef.end_vertex].x_position, y: map.vertexes[linedef.start_vertex].y_position))
            )*(180/Math::PI)
          )
        else
          raise "Texture is not loaded! #{map.sidedefs[linedef.front_sidedef].name_tex_mid}"
        end
      end

      # R.draw_billboard(
      #   world_space_camera,
      #   test_texture,
      #   R::Vector3.new(x: 0, y: 0, z: 0),
      #   10.0,
      #   R::WHITE
      # )

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

    loaded_textures.each do |texture|
      R.unload_texture(texture.texture)
    end

    R.close_window
  end
end

# Draws a texture in 3D space with pro parameters
def self.draw_texture_pro_3d(texture : Raylib::Texture2D, source_rec : Raylib::Rectangle, dest_rec : Raylib::Rectangle, origin : Raylib::Vector3 = Raylib::Vector3.new(x: 0, y: 0, z: 0), rotation : Float = 0.0, z_rotate : Float = 0.0, pos_z : Float = 0.0, tint : Raylib::Color = Raylib::WHITE)
  if Raylib.texture_ready?(texture)
    width = texture.width
    height = texture.height

    flip_x = false

    if source_rec.width < 0
      flip_x = true
      source_rec.width *= -1
    end

    if source_rec.height < 0
      source_rec.y -= source_rec.height
    end

    RLGL.push_matrix
    RLGL.translate_f(dest_rec.x, dest_rec.y, 0.0)
    RLGL.rotate_f(rotation, 0.0, 0.0, 1.0)
    RLGL.translate_f(-origin.x, -origin.y, -origin.z)
    RLGL.rotate_f(z_rotate, 0.0, 1.0, 0.0)
    RLGL.push_matrix
    draw_texture(width, height, flip_x, texture, source_rec, dest_rec, origin, rotation, pos_z, tint)
    RLGL.pop_matrix
    RLGL.pop_matrix
  end
end

def self.draw_texture(width : Int, height : Int, flip_x : Bool, texture : Raylib::Texture2D, source_rec : Raylib::Rectangle, dest_rec : Raylib::Rectangle, origin : Raylib::Vector3, rotation : Float, pos_z : Float, tint : Raylib::Color)
  RLGL.set_texture(texture.id)
  RLGL.begin(RLGL::QUADS)
  RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)
  # Normal vector pointing towards viewer
  RLGL.normal_3f(0.0, 0.0, 1.0)
  # Bottom-left corner for texture and quad
  if flip_x
    RLGL.texcoord_2f((source_rec.x + source_rec.width)/width, source_rec.y/height)
  else
    RLGL.texcoord_2f(source_rec.x/width, source_rec.y/height)
  end
  RLGL.vertex_3f(0.0, 0.0, pos_z)

  # Bottom-right corner for texture and quad
  if flip_x
    RLGL.texcoord_2f((source_rec.x + source_rec.width)/width, (source_rec.y + source_rec.height)/height)
  else
    RLGL.texcoord_2f(source_rec.x/width, (source_rec.y + source_rec.height)/height)
  end
  RLGL.vertex_3f(0.0, dest_rec.height, pos_z)

  # Top-right corner for texture and quad
  if flip_x
    RLGL.texcoord_2f(source_rec.x/width, (source_rec.y + source_rec.height)/height)
  else
    RLGL.texcoord_2f((source_rec.x + source_rec.width)/width, (source_rec.y + source_rec.height)/height)
  end
  RLGL.vertex_3f(dest_rec.width, dest_rec.height, pos_z)

  # Top-left corner for texture and quad
  if flip_x
    RLGL.texcoord_2f(source_rec.x/width, source_rec.y/height)
  else
    RLGL.texcoord_2f((source_rec.x + source_rec.width)/width, source_rec.y/height)
  end
  RLGL.vertex_3f(dest_rec.width, 0.0, pos_z)
  RLGL.end
  RLGL.set_texture(0)
end

MapViewer.run
