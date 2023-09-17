module Apps
  module WadViewer
    VERSION = "1.0.0"

    WINDOW_RESX = 1920
    WINDOW_RESY = 1440

    RESX = 800
    RESY = 600

    DIRECTORIES_PANEL_ITEMS_HEIGHT        = 20
    DIRECTORIES_PANEL_ITEMS_SPACING       =  0
    DIRECTORIES_PANEL_STATUSBAR_TEXT_SIZE = 25
    DIRECTORIES_PANEL_TEXT_SIZE           = 14
    DIRECTORIES_PANEL_TEXT_COLOR          = Raylib.color_to_int(Raylib::Color.new(r: 66, g: 176, b: 245, a: 200))
    DIRECTORIES_PANEL_TEXT_SELECTED_COLOR = Raylib.color_to_int(Raylib::Color.new(r: 237, g: 36, b: 36, a: 200))
    DIRECTORIES_PANEL_TEXT_EDITED_COLOR   = Raylib.color_to_int(Raylib::Color.new(r: 11, g: 57, b: 156, a: 200))

    WAD_SAVE_PANEL_HEADER_TEXT_SIZE      = 16
    WAD_SAVE_PANEL_TEXT_SIZE             = 10
    WAD_SAVE_PANEL_TEXT_DEFAULT_COLOR    = Raylib.color_to_int(Raylib::Color.new(r: 23, g: 81, b: 103, a: 200))
    WAD_SAVE_PANEL_TEXT_COMPLETE_COLOR   = Raylib.color_to_int(Raylib::Color.new(r: 13, g: 255, b: 53, a: 200))
    WAD_SAVE_PANEL_TEXT_FAILED_COLOR     = Raylib.color_to_int(Raylib::Color.new(r: 255, g: 34, b: 0, a: 200))
    WAD_SAVE_PANEL_TEXT_NOFILENAME_COLOR = Raylib.color_to_int(Raylib::Color.new(r: 255, g: 0, b: 255, a: 200))
    WAD_SAVE_PANEL_TEXT_WORKING_COLOR    = Raylib.color_to_int(Raylib::Color.new(r: 0, g: 255, b: 195, a: 200))
    WAD_SAVE_PANEL_TEXT_WAITING_COLOR    = Raylib.color_to_int(Raylib::Color.new(r: 0, g: 195, b: 255, a: 200))

    LUMP_INFO_PANEL_TEXT_SIZE = 10

    # :nodoc:
    alias RL = Raylib
    # :nodoc:
    alias RM = Raymath
    # :nodoc:
    alias RG = Raygui

    def self.remove_nulls(string : String) : String
      new_string = String.build do |str|
        string.chars.each do |char|
          str << char if char.ord.to_u8 != 0
        end
      end
      return new_string
    end

    def self.run(input_file : String)
      raise "ERROR: '#{input_file}' IS NOT A VALID .wad FILE" unless File.exists?(input_file)
      wad = WAD.read(input_file)
      self.run(wad)
    end

    def self.run(wad : WAD)
      RL.init_window(WINDOW_RESX, WINDOW_RESY, "Wad Viewer")
      RL.set_window_state(RL::ConfigFlags::WindowResizable)
      RL.set_target_fps(60)
      RL.set_window_min_size(320, 240)

      default_base_button_normal_color = RG.get_style(RG::Control::Button, RG::ControlProperty::BaseColorNormal)
      default_border_button_normal_color = RG.get_style(RG::Control::Button, RG::ControlProperty::BorderColorNormal)
      default_base_button_focused_color = RG.get_style(RG::Control::Button, RG::ControlProperty::BaseColorFocused)
      default_border_button_focused_color = RG.get_style(RG::Control::Button, RG::ControlProperty::BorderColorFocused)

      draw_directories_panel = true
      draw_tools_panel = true
      draw_file_save_panel = false
      draw_wad_info_panel = true
      draw_lump_info_panel = true
      draw_playpal_panel = false
      draw_graphic_panel = false
      draw_map_info_panel = false

      target = RL.load_render_texture(RESX, RESY)
      RL.set_texture_filter(target.texture, RL::TextureFilter::Bilinear)

      # Screen Layout Start

      directories_panel_rec = RL::Rectangle.new(width: 160, height: target.texture.height)
      directories_panel_content_rec = RL::Rectangle.new
      directories_panel_scroll = RL::Vector2.new
      directories_panel_view_rec = RL::Rectangle.new

      tools_panel_rec = RL::Rectangle.new(
        x: directories_panel_rec.width + 5,
        y: 10,
        width: 220,
        height: 32)
      tools_panel_button_rec = RL::Rectangle.new(
        x: tools_panel_rec.x + 4,
        y: tools_panel_rec.y + 8,
        width: 20,
        height: 20
      )

      save_panel_rec = RL::Rectangle.new(
        x: RESX/2 - 288/2,
        y: 60,
        width: 288,
        height: 58
      )
      wad_save_filename = ""
      wad_save_status_value = ["complete", "failed", "no filename", "working", "waiting"]
      wad_save_status = 4

      wad_info_panel_rec = RL::Rectangle.new(
        x: tools_panel_rec.x,
        y: tools_panel_rec.y + tools_panel_rec.height + 10,
        width: tools_panel_rec.width,
        height: 100
      )

      lump_info_panel_rec = RL::Rectangle.new(
        x: wad_info_panel_rec.x,
        y: wad_info_panel_rec.y + wad_info_panel_rec.height + 10,
        width: wad_info_panel_rec.width,
        height: 40
      )

      playpal_panel_rec = RL::Rectangle.new(
        x: tools_panel_rec.x + tools_panel_rec.width + 10,
        y: tools_panel_rec.y,
        width: 346,
        height: 34 + (24*(wad.playpal.palettes[0].colors.size//13))
      )
      playpal_selected_palette = 1
      playpal_selected_index = 0

      file_save_panel_rec = RL::Rectangle.new(
        x: RESX/2 - 288/2,
        y: 60,
        width: 288,
        height: 58
      )

      graphic_panel_rec = RL::Rectangle.new(
        x: tools_panel_rec.x + tools_panel_rec.width + 10,
        y: tools_panel_rec.y,
        width: 346,
        height: 400
      )
      graphic_panel_target_rec = RL::Rectangle.new(
        x: graphic_panel_rec.x + 5,
        y: graphic_panel_rec.y + 15,
        width: graphic_panel_rec.width - 10,
        height: graphic_panel_rec.height - 25
      )
      current_texture = nil
      graphic_viewer_target = nil
      graphic_viewer_camera = RL::Camera2D.new
      graphic_viewer_camera.zoom = 1.0_f32

      # Screen Layout End

      wad_saved = wad.clone
      wad_unsaved = wad.clone

      # Directory, Index, Edit_mode, Edited
      directories = [] of Tuple(WAD::Directory, Int32, Bool, Bool)
      selected_directory = WAD::Directory.new

      wad_saved.directories.each.with_index do |directory, index|
        if wad_saved.what_is?(directory.name) == "Map"
          directory.size += wad_saved.maps[directory.name].things_directory.size
          directory.size += wad_saved.maps[directory.name].linedefs_directory.size
          directory.size += wad_saved.maps[directory.name].sidedefs_directory.size
          directory.size += wad_saved.maps[directory.name].vertexes_directory.size
          directory.size += wad_saved.maps[directory.name].segs_directory.size
          directory.size += wad_saved.maps[directory.name].ssectors_directory.size
          directory.size += wad_saved.maps[directory.name].nodes_directory.size
          directory.size += wad_saved.maps[directory.name].sectors_directory.size
          directory.size += wad_saved.maps[directory.name].reject_directory.size
          directory.size += wad_saved.maps[directory.name].blockmap_directory.size
        end

        directories << {directory, index, false, false}
      end

      until RL.close_window?
        # UPDATE START

        scale = RL::Vector2.new(x: RL.get_screen_width/RESX, y: RL.get_screen_height/RESY)
        if scale.x < scale.y
          scale = scale.x
        else
          scale = scale.y
        end

        RL.set_mouse_offset(-(RL.get_screen_width - (RESX*scale))*0.5, -(RL.get_screen_height - (RESY*scale))*0.5)
        RL.set_mouse_scale(1/scale, 1/scale)

        directories_panel_text_height = RG.get_style(RG::Control::ListView, RG::ListViewProperty::ItemsHeight)
        directories_panel_text_spacing = RG.get_style(RG::Control::ListView, RG::ListViewProperty::ItemsSpacing)

        draw_playpal_panel = wad_unsaved.what_is?(selected_directory.name) == "Playpal"
        draw_map_info_panel = wad_unsaved.what_is?(selected_directory.name) == "Map"
        draw_graphic_panel = (wad_unsaved.what_is?(selected_directory.name) == "Graphic" ||
                              wad_unsaved.what_is?(selected_directory.name) == "Sprite" ||
                              wad_unsaved.what_is?(selected_directory.name) == "Flat")

        playpal_selected_index = 0 if !draw_playpal_panel

        # UPDATE END

        # DRAW TEXTURE VIEWER START

        if draw_graphic_panel
          if current_texture.nil?
            case wad_unsaved.what_is?(selected_directory.name)
            when "Graphic"
              image = wad_unsaved.graphics[selected_directory.name].to_image(wad_unsaved.playpal.palettes[playpal_selected_palette - 1])
              current_texture = RL.load_texture_from_image(image)
              RL.unload_image(image)
            when "Sprite"
              image = wad_unsaved.sprites[selected_directory.name].to_image(wad_unsaved.playpal.palettes[playpal_selected_palette - 1])
              current_texture = RL.load_texture_from_image(image)
              RL.unload_image(image)
            when "Flat"
              image = wad_unsaved.flats[selected_directory.name].to_image(wad_unsaved.playpal.palettes[playpal_selected_palette - 1])
              current_texture = RL.load_texture_from_image(image)
              RL.unload_image(image)
            end
          else
          end

          if graphic_viewer_target.nil? && current_texture
            graphic_viewer_target = RL.load_render_texture(graphic_panel_target_rec.width, graphic_panel_target_rec.height)
          end

          if graphic_viewer_target && current_texture
            RL.begin_texture_mode(graphic_viewer_target)
            RL.clear_background(RL::BLANK)
            RL.begin_mode_2d(graphic_viewer_camera)
            RL.draw_texture(current_texture, 0, 0, RL::WHITE)
            RL.end_mode_2d
            RL.end_texture_mode
          end
        else
          if current_texture
            RL.unload_texture(current_texture)
            current_texture = nil
          end

          if graphic_viewer_target
            RL.unload_render_texture(graphic_viewer_target)
            graphic_viewer_target = nil
          end
        end

        # DRAW TEXTURE VIEWER END

        RL.begin_texture_mode(target)
        RL.clear_background(RL::RAYWHITE)

        # DRAW START

        # Draw directories panel
        if draw_directories_panel
          RG.set_style(RG::Control::ListView, RG::ListViewProperty::ItemsHeight, DIRECTORIES_PANEL_ITEMS_HEIGHT)
          RG.set_style(RG::Control::ListView, RG::ListViewProperty::ItemsSpacing, DIRECTORIES_PANEL_ITEMS_SPACING)
          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, DIRECTORIES_PANEL_STATUSBAR_TEXT_SIZE)
          RG.set_style(RG::Control::StatusBar, RG::ControlProperty::TextAlignment, RG::TextAlignment::Center)

          RG.scroll_panel(
            directories_panel_rec,
            "Directories",
            directories_panel_content_rec,
            pointerof(directories_panel_scroll),
            pointerof(directories_panel_view_rec)
          )

          RL.begin_scissor_mode(
            directories_panel_view_rec.x,
            directories_panel_view_rec.y,
            directories_panel_view_rec.width,
            directories_panel_view_rec.height
          )

          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, DIRECTORIES_PANEL_TEXT_SIZE)
          RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorNormal, DIRECTORIES_PANEL_TEXT_COLOR)
          RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorPressed, DIRECTORIES_PANEL_TEXT_SELECTED_COLOR)
          RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextAlignment, RG::TextAlignment::Left)

          directories_panel_content_rec.height = 0
          directories.each do |directory, index, edit_mode, edited|
            line_width = RL.measure_text("XXXXXXXXXX", RG.get_style(RG::Control::Default, RG::DefaultProperty::TextSize))
            line_width += RL.measure_text("XXXXXXXXXX", RG.get_style(RG::Control::Default, RG::DefaultProperty::TextSize))

            directory.name = directory.name.lchop('?')

            slice = Slice.new(8, 0_u8)
            directory.name.chars.each.with_index do |char, index|
              slice[index] = char.ord.to_u8
            end
            dir_name_io = IO::Memory.new(slice)
            dir_name_io.read(slice)
            name = String.new(slice)

            text_width = RL.measure_text("XXXXXXXXXX", RG.get_style(RG::Control::Default, RG::DefaultProperty::TextSize))

            if directory.name == selected_directory.name
              RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorNormal, DIRECTORIES_PANEL_TEXT_SELECTED_COLOR)
            elsif edited
              RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorNormal, DIRECTORIES_PANEL_TEXT_EDITED_COLOR)
            else
              RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorNormal, DIRECTORIES_PANEL_TEXT_COLOR)
            end

            if directory != selected_directory
              edit_mode = false
            end

            if RG.text_box(
                 RL::Rectangle.new(
                   x: directories_panel_view_rec.x + directories_panel_scroll.x,
                   y: directories_panel_view_rec.y + directories_panel_scroll.y + directories_panel_text_height*index + directories_panel_text_spacing*index,
                   width: text_width,
                   height: directories_panel_text_height
                 ),
                 name,
                 9,
                 edit_mode
               )
              edit_mode = !edit_mode
              RL.unload_texture(current_texture) if current_texture
              current_texture = nil
              # Causes hickup in program
              # RL.unload_render_texture(graphic_viewer_target) if graphic_viewer_target
              graphic_viewer_target = nil
              selected_directory = directory
            end

            RG.set_style(RG::Control::TextBox, RG::ControlProperty::TextColorNormal, DIRECTORIES_PANEL_TEXT_COLOR)

            RG.text_box(
              RL::Rectangle.new(
                x: directories_panel_view_rec.x + directories_panel_scroll.x + text_width,
                y: directories_panel_view_rec.y + directories_panel_scroll.y + directories_panel_text_height*index + directories_panel_text_spacing*index,
                width: 100,
                height: directories_panel_text_height
              ),
              wad_unsaved.what_is?(directory.name),
              100,
              false
            )

            name = self.remove_nulls(name)
            edited = wad_saved.directories[index].name != WAD.string_sub_chars(name)

            directory.name = "?#{WAD.string_sub_chars(name)}"
            directories[index] = {directory, index, edit_mode, edited}

            if wad_unsaved.directories[index].name != directory.name.lchop
              changed_dir = WAD::Directory.new
              changed_dir.file_pos = directory.file_pos
              changed_dir.size = directory.size
              changed_dir.name = directory.name.lchop
              selected_directory = changed_dir
              wad_unsaved.rename_lump(wad_unsaved.directories[index].name, directory.name.lchop)
              wad_unsaved.directories[index] = changed_dir
            end

            directories_panel_content_rec.width = line_width if line_width > directories_panel_content_rec.width
            directories_panel_content_rec.height += directories_panel_text_height + directories_panel_text_spacing
          end

          RL.end_scissor_mode
        end

        RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, LUMP_INFO_PANEL_TEXT_SIZE)

        # Draw WAD info panel
        if draw_wad_info_panel
          RG.group_box(
            wad_info_panel_rec,
            "WAD Info"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 15,
              width: 200,
              height: 0
            ),
            "Type: #{wad_unsaved.type}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 15,
              width: 200,
              height: 0
            ),
            "Dir Pointer: #{wad_unsaved.directory_pointer}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "Lumps: #{wad_unsaved.directories_count}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "Maps: #{wad_unsaved.maps.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 45,
              width: 200,
              height: 0
            ),
            "PcSounds: #{wad_unsaved.pcsounds.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 45,
              width: 200,
              height: 0
            ),
            "Sounds: #{wad_unsaved.sounds.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 60,
              width: 200,
              height: 0
            ),
            "Music: #{wad_unsaved.music.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 60,
              width: 200,
              height: 0
            ),
            "TexMaps: #{wad_unsaved.texmaps.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 75,
              width: 200,
              height: 0
            ),
            "Graphics: #{wad_unsaved.graphics.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 75,
              width: 200,
              height: 0
            ),
            "Sprites: #{wad_unsaved.sprites.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 5,
              y: wad_info_panel_rec.y + 90,
              width: 200,
              height: 0
            ),
            "Flats: #{wad_unsaved.flats.size}"
          )
          RG.label(
            RL::Rectangle.new(
              x: wad_info_panel_rec.x + 110,
              y: wad_info_panel_rec.y + 90,
              width: 200,
              height: 0
            ),
            "Demos: #{wad_unsaved.demos.size}"
          )
        end

        # Draw lump info panel
        if draw_lump_info_panel
          RG.group_box(
            lump_info_panel_rec,
            "Lump Info"
          )
          RG.label(
            RL::Rectangle.new(
              x: lump_info_panel_rec.x + 5,
              y: lump_info_panel_rec.y + 15,
              width: 200,
              height: 0
            ),
            "Name: '#{selected_directory.name}'"
          )
          RG.label(
            RL::Rectangle.new(
              x: lump_info_panel_rec.x + 110,
              y: lump_info_panel_rec.y + 15,
              width: 200,
              height: 0
            ),
            "Size: '#{selected_directory.size}'"
          )
          RG.label(
            RL::Rectangle.new(
              x: lump_info_panel_rec.x + 5,
              y: lump_info_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "Type: '#{wad_unsaved.what_is?(selected_directory.name)}'"
          )
          RG.label(
            RL::Rectangle.new(
              x: lump_info_panel_rec.x + 110,
              y: lump_info_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "File Pos: '#{selected_directory.file_pos}'"
          )
        end

        # Draw tools panel
        if draw_tools_panel
          RG.group_box(
            tools_panel_rec,
            "Tools"
          )

          RG.set_tooltip("Save as")
          RG.enable_tooltip
          if RG.button(
               RL::Rectangle.new(
                 x: tools_panel_button_rec.x,
                 y: tools_panel_button_rec.y,
                 width: tools_panel_button_rec.width,
                 height: tools_panel_button_rec.height
               ),
               RG.icon_text(RG::IconName::FileSave, nil)
             )
            draw_file_save_panel = !draw_file_save_panel
          end
          RG.disable_tooltip

          RG.set_tooltip("Save")
          RG.enable_tooltip
          if RG.button(
               RL::Rectangle.new(
                 x: tools_panel_button_rec.x + tools_panel_button_rec.width + 2,
                 y: tools_panel_button_rec.y,
                 width: tools_panel_button_rec.width,
                 height: tools_panel_button_rec.height
               ),
               RG.icon_text(RG::IconName::FileSaveClassic, nil)
             )
            if wad_save_filename.empty?
              draw_file_save_panel = !draw_file_save_panel
            else
              wad_save_status = 3

              wad_save_filename = wad_save_filename.lchop('?')
              wad_save_filename = WAD.string_sub_chars(wad_save_filename)

              if wad_save_filename.size > 0
                begin
                  if wad_save_filename.size >= 255
                    wad_save_filename = wad_save_filename[0...-4]
                    wad_save_filename += ".wad"
                  elsif (wad_save_filename.size < 4) ||
                        (wad_save_filename[-4..-1] != "~wad") ||
                        (wad_save_filename == "~wad")
                    wad_save_filename += ".wad"
                  else
                    wad_save_filename = wad_save_filename[0...-4] + ".wad"
                  end

                  wad_saved = wad_unsaved.clone
                  wad_saved.write("./rsrc/wad-viewer/#{wad_save_filename}")
                rescue
                  wad_save_status = 1
                end
              else
                wad_save_status = 2
              end

              wad_save_status = 0 if wad_save_status != 1 && wad_save_status != 2
            end
          end
          RG.disable_tooltip
        end

        # Draw playpal panel
        if draw_playpal_panel
          RG.group_box(
            playpal_panel_rec,
            "Playpal"
          )

          RG.line(
            RL::Rectangle.new(
              x: playpal_panel_rec.x,
              y: playpal_panel_rec.y + 24,
              width: playpal_panel_rec.width,
              height: 4
            ),
            nil
          )

          if RG.button(
               RL::Rectangle.new(
                 x: playpal_panel_rec.x + 5,
                 y: playpal_panel_rec.y + 8,
                 width: 14,
                 height: 14
               ),
               RG.icon_text(RG::IconName::ArrowLeft, nil)
             )
            playpal_selected_palette -= 1
            playpal_selected_palette = wad_unsaved.playpal.palettes.size if playpal_selected_palette == 0
            playpal_selected_palette = playpal_selected_palette.clamp(1, wad_unsaved.playpal.palettes.size)
          end

          if RG.button(
               RL::Rectangle.new(
                 x: playpal_panel_rec.x + 26,
                 y: playpal_panel_rec.y + 8,
                 width: 14,
                 height: 14
               ),
               RG.icon_text(RG::IconName::ArrowRight, nil)
             )
            playpal_selected_palette += 1
            playpal_selected_palette = 0 if playpal_selected_palette == wad_unsaved.playpal.palettes.size + 1
            playpal_selected_palette = playpal_selected_palette.clamp(1, wad_unsaved.playpal.palettes.size)
          end

          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, 14)
          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextAlignmentVertical, RG::TextAlignmentVertical::Middle)

          RG.label(
            RL::Rectangle.new(
              x: playpal_panel_rec.x + 42,
              y: playpal_panel_rec.y + 8,
              width: 100,
              height: 14
            ),
            "Pallete: #{playpal_selected_palette}/#{wad_unsaved.playpal.palettes.size}"
          )

          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, 12)

          RG.label(
            RL::Rectangle.new(
              x: playpal_panel_rec.x + 140,
              y: playpal_panel_rec.y + 8,
              width: 300,
              height: 14
            ),
            "Index: #{playpal_selected_index}   " +
            "R: #{wad_unsaved.playpal.palettes[playpal_selected_palette - 1].colors[playpal_selected_index].r}, " +
            "G: #{wad_unsaved.playpal.palettes[playpal_selected_palette - 1].colors[playpal_selected_index].g}, " +
            "B: #{wad_unsaved.playpal.palettes[playpal_selected_palette - 1].colors[playpal_selected_index].b}"
          )

          wad_unsaved.playpal.palettes[playpal_selected_palette - 1].colors.each.with_index do |color, index|
            if playpal_selected_index == index
              RG.set_style(RG::Control::Button, RG::ControlProperty::BorderColorNormal, RL.color_to_int(RL::Color.new(r: 220, g: 220, b: 220, a: 255)))
            else
              RG.set_style(RG::Control::Button, RG::ControlProperty::BorderColorNormal, RL.color_to_int(RL::Color.new(r: 140, g: 140, b: 140, a: 255)))
            end
            RG.set_style(RG::Control::Button, RG::ControlProperty::BaseColorNormal, RL.color_to_int(RL::Color.new(r: color.r, g: color.g, b: color.b, a: 255)))
            RG.set_style(RG::Control::Button, RG::ControlProperty::BaseColorFocused, RL.color_to_int(RL::Color.new(r: color.r, g: color.g, b: color.b, a: 255)))
            RG.set_style(RG::Control::Button, RG::ControlProperty::BorderColorFocused, RL.color_to_int(RL::Color.new(r: 160, g: 160, b: 160, a: 255)))

            if RG.button(
                 RL::Rectangle.new(
                   x: playpal_panel_rec.x + 5 + (index*24) - (24*(index//14)*14),
                   y: playpal_panel_rec.y + 30 + (24*(index//14)),
                   width: 24,
                   height: 24
                 ),
                 nil
               )
              playpal_selected_index = index
            end
          end
        end

        # Draw graphic panel
        if draw_graphic_panel
          RG.group_box(
            graphic_panel_rec,
            "Graphic Viewer"
          )
          RG.grid(graphic_panel_target_rec, nil, 12, 1, nil)

          if graphic_viewer_target
            RL.draw_texture_pro(
              graphic_viewer_target.texture,
              RL::Rectangle.new(
                width: graphic_viewer_target.texture.width,
                height: -graphic_viewer_target.texture.height
              ),
              graphic_panel_target_rec,
              RL::Vector2.new,
              0,
              RL::WHITE
            )
          end
        end

        RG.set_style(RG::Control::Button, RG::ControlProperty::BaseColorNormal, default_base_button_normal_color)
        RG.set_style(RG::Control::Button, RG::ControlProperty::BorderColorNormal, default_border_button_normal_color)
        RG.set_style(RG::Control::Button, RG::ControlProperty::BaseColorFocused, default_base_button_focused_color)
        RG.set_style(RG::Control::Button, RG::ControlProperty::BorderColorFocused, default_border_button_focused_color)

        # Draw map info panel
        if draw_map_info_panel
        end

        RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, WAD_SAVE_PANEL_HEADER_TEXT_SIZE)

        # Draw WAD save panel
        if draw_file_save_panel
          wad_save_filename = wad_save_filename.lchop('?')
          slice = Slice.new(255, 0_u8)
          i = 0
          wad_save_filename.chars.each do |char|
            next if char.ord.to_u8 == 0
            slice[i] = char.ord.to_u8
            i += 1
          end
          wad_filename_io = IO::Memory.new(slice)
          wad_filename_io.read(slice)
          wad_filename = String.new(slice)

          if RG.window_box(save_panel_rec, "Save WAD")
            draw_file_save_panel = false
          end
          RG.text_box(
            RL::Rectangle.new(
              x: save_panel_rec.x + 2,
              y: save_panel_rec.y + 36,
              width: 260,
              height: 20
            ),
            wad_filename,
            256,
            true
          )

          wad_filename = self.remove_nulls(wad_filename)

          wad_save_filename = "?#{wad_filename}"

          RG.set_style(RG::Control::Default, RG::DefaultProperty::TextSize, WAD_SAVE_PANEL_TEXT_SIZE)

          RG.label(
            RL::Rectangle.new(
              x: save_panel_rec.x + 2,
              y: save_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "Filename:"
          )

          RG.label(
            RL::Rectangle.new(
              x: save_panel_rec.x + save_panel_rec.width - 140,
              y: save_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "Status: "
          )

          case wad_save_status
          when 0
            RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_COMPLETE_COLOR)
          when 1
            RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_FAILED_COLOR)
          when 2
            RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_NOFILENAME_COLOR)
          when 3
            RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_WORKING_COLOR)
          when 4
            RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_WAITING_COLOR)
          end

          RG.label(
            RL::Rectangle.new(
              x: save_panel_rec.x + save_panel_rec.width - 100,
              y: save_panel_rec.y + 30,
              width: 200,
              height: 0
            ),
            "#{wad_save_status_value[wad_save_status]}"
          )

          RG.set_style(RG::Control::Label, RG::ControlProperty::TextColorNormal, WAD_SAVE_PANEL_TEXT_DEFAULT_COLOR)

          RG.set_tooltip("Save")
          RG.enable_tooltip
          if RG.button(
               RL::Rectangle.new(
                 x: save_panel_rec.x + save_panel_rec.width - 24,
                 y: save_panel_rec.y + 30,
                 width: 20,
                 height: 20
               ),
               RG.icon_text(RG::IconName::FileSave, nil)
             )
            wad_save_status = 3

            wad_save_filename = wad_save_filename.lchop('?')
            wad_save_filename = WAD.string_sub_chars(wad_save_filename)

            if wad_save_filename.size > 0
              begin
                if wad_save_filename.size >= 255
                  wad_save_filename = wad_save_filename[0...-4]
                  wad_save_filename += ".wad"
                elsif (wad_save_filename.size < 4) ||
                      (wad_save_filename[-4..-1] != "~wad") ||
                      (wad_save_filename == "~wad")
                  wad_save_filename += ".wad"
                else
                  wad_save_filename = wad_save_filename[0...-4] + ".wad"
                end

                wad_saved = wad_unsaved.clone
                wad_saved.write("./rsrc/wad-viewer/#{wad_save_filename}")
              rescue
                wad_save_status = 1
              end
            else
              wad_save_status = 2
            end

            wad_save_status = 0 if wad_save_status != 1 && wad_save_status != 2
          end
          RG.disable_tooltip
        else
          wad_save_status = 4
        end

        # DRAW END

        RL.end_texture_mode

        RL.begin_drawing

        RL.clear_background(RL::BLACK)

        RL.draw_texture_pro(
          target.texture,
          RL::Rectangle.new(width: target.texture.width, height: -target.texture.height),
          RL::Rectangle.new(
            x: (RL.get_screen_width - (RESX*scale))*0.5,
            y: (RL.get_screen_height - (RESY*scale))*0.5,
            width: RESX*scale,
            height: RESY*scale
          ),
          RL::Vector2.new,
          0,
          RL::WHITE
        )

        RL.end_drawing
      end

      RL.unload_render_texture(target)

      RL.close_window
    end
  end
end
