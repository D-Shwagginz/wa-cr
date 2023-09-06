module A_Overview
  module C_Usage
    # wa-cr's `RaylibAdditions` allow converting `WAD::Graphic`s and `WAD::Flat`s
    # to [Raylib Images](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
    # or [Raylib Colors](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # which can then be drawn to the screen.<br>
    # For more information on Raylib, visit it's [Github](https://github.com/raysan5/raylib/releases)
    # and visit the raylib-cr [Github](https://github.com/sol-vin/raylib-cr)<br>
    # To use the `RaylibAdditions`, just require `wa-cr/raylib`:
    #
    # ```
    # require "wa-cr/raylib"
    # ```
    #
    # To convert a `WAD::Graphic` or a `WAD::Flat` to a `Raylib::Image`
    # you call `.to_image(palette)` on the graphic or flat.
    # You'll need to select the `WAD::Playpal::Palette` you want to use
    # for the image:
    #
    # NOTE: Each pixel of a graphic or flat points to an array element in a playpal palette.
    # For more information on Doom's picture format, visit the wiki entries on the
    # [Picture Format](https://doomwiki.org/wiki/Picture_format) and on the
    # [Playpal](https://doomwiki.org/wiki/PLAYPAL)
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_graphic = WAD::Graphic.parse("Path/To/MyGraphic.lmp")
    #
    # my_flat = WAD::Flat.parse("Path/To/MyFlat.lmp")
    #
    # # The default Doom Playpal has a total of 14 palettes (0-13)
    # palette = my_wad.playpal.palettes[0]
    #
    # my_graphic_image = my_graphic.to_image(palette) # => Returns a Raylib::Image
    #
    # my_flat_image = my_flat.to_image(palette) # => Returns a Raylib::Image
    # ```
    #
    # To get some pixel data, call `.get_pixel(x, y, palette):
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_graphic_pixel = my_graphic.get_pixel(3, 8, palette) # => Returns a Raylib::Color
    #
    # my_flat_pixel = my_flat.get_pixel(62, 20, palette) # => Returns a Raylib::Color
    # ```
    #
    # With this image and pixel data, you can use [Raylib](https://github.com/raysan5/raylib/releases)
    # and [raylib-cr](https://github.com/sol-vin/raylib-cr) to draw it to the screen.<br>
    # Here is a simple example of how to draw `my_graphic_image` and `my_flat_image`:
    #
    # NOTE: When requiring `wa-cr/raylib`, you don't need to also require `raylib-cr` since
    # `wa-cr/raylib` requires `raylib-cr` anyways
    #
    # ```
    # require "wa-cr/raylib"
    #
    # Raylib.init_window(800, 450, "Image Viewer")
    # Raylib.set_target_fps(60)
    #
    # my_graphic = WAD::Graphic.parse("Path/To/MyGraphic.lmp")
    # my_flat = WAD::Flat.parse("Path/To/MyFlat.lmp")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_graphic_image = my_graphic.to_image(palette)
    # my_flat_image = my_flat.to_image(palette)
    #
    # # You can't draw images to the screen,
    # # so you need to load them into a texture.
    #
    # # Note that Raylib::Texture2D's can't be set
    # # as variables until the window has been initialized.
    # my_graphic_texture = Raylib.load_texture_from_image(my_graphic_image)
    #
    # my_flat_texture = Raylib.load_texture_from_image(my_flat_image)
    #
    # until Raylib.close_window?
    #   Raylib.begin_drawing
    #   Raylib.clear_background(Raylib::RAYWHITE)
    #
    #   Raylib.draw_texture(my_graphic_texture, 0, 0, Raylib::WHITE)
    #
    #   # Sets the texture's x to the screen's width minus the width of the
    #   # texture to have it be in the top right.
    #   # Textures are drawn from the top left.
    #   Raylib.draw_texture(
    #     my_graphic_texture,
    #     (Raylib.get_screen_width - my_graphic_texture.width),
    #     0,
    #     Raylib::White
    #   )
    #
    #   Raylib.end_drawing
    # end
    #
    # Raylib.close_window
    # ```
    module H_UsingWithRaylib
    end
  end
end
