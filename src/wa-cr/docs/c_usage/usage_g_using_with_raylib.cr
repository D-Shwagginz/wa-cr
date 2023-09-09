module Documentation
  module C_Usage
    # wa-cr's `RaylibAdditions` allow converting `WAD::Graphic`s and `WAD::Flat`s
    # to [Raylib Images](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
    # or [Raylib Colors](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # which can then be drawn to the screen.<br>
    # For more information on Raylib, visit it's [Github](https://github.com/raysan5/raylib/releases)<br>
    # And visit the raylib-cr [Github](https://github.com/sol-vin/raylib-cr)
    # for information on the Raylib Crystal C-Bindings
    #
    # NOTE: Some file conversion methods that `RaylibAdditions` contains are not
    # mentioned here, but in [E_ConvertingFileTypes](https://sol-vin.github.io/wad-reader/Documentation/C_Usage/E_ConvertingFileTypes.html#the-following-convertion-methods-use-raylib-additions)
    #
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
    # NOTE: Each pixel of a graphic or a flat points to an array element in a playpal palette.
    # For more information on Doom's picture format and the playpal, visit the wiki entries on the
    # [Picture Format](https://doomwiki.org/wiki/Picture_format) and the
    # [Playpal](https://doomwiki.org/wiki/PLAYPAL)
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/MyWad.WAD")
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
    # You can also get textures out of the texture maps by using `RaylibAdditions::WAD#get_texture(name, palette):
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/MyWad.WAD")
    #
    # palette = my
    #
    # my_texture_image = my_wad.get_texture("STARTAN3", palette) # => Returns a Raylib::Image
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
    # Here is a simple example of how to draw `my_texture_image`, `my_graphic_image`, and `my_flat_image`:
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
    # my_wad = WAD.read("Path/To/MyWad.WAD")
    #
    # my_graphic = WAD::Graphic.parse("Path/To/MyGraphic.lmp")
    # my_flat = WAD::Flat.parse("Path/To/MyFlat.lmp")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_texture_image = my_wad.get_texture("STARTAN3", palette)
    # my_graphic_image = my_graphic.to_image(palette)
    # my_flat_image = my_flat.to_image(palette)
    #
    # # You can't draw images to the screen,
    # # so you need to load them into a textures.
    #
    # # Note that Raylib::Texture2D's can't be set
    # # as variables until the window has been initialized.
    # my_texture_texture = Raylib.load_texture_from_image(my_texture_image)
    #
    # my_graphic_texture = Raylib.load_texture_from_image(my_graphic_image)
    #
    # my_flat_texture = Raylib.load_texture_from_image(my_flat_image)
    #
    # until Raylib.close_window?
    #   Raylib.begin_drawing
    #   Raylib.clear_background(Raylib::RAYWHITE)
    #
    #   Raylib.draw_texture(my_texture_texture, 0, 0, Raylib::WHITE)
    #
    #   # Sets the texture's x to be the screen's width minus the
    #   # width of the texture to have it be in the top right.
    #   # Textures are drawn from the top left.
    #   Raylib.draw_texture(
    #     my_graphic_texture,
    #     (Raylib.get_screen_width - my_graphic_texture.width),
    #     0,
    #     Raylib::WHITE
    #   )
    #
    #   # Sets the texture's y to be the screen's height minus the
    #   # height of the texture to have it be in the bottom left.
    #   Raylib.draw_texture(
    #     my_flat_texture,
    #     0,
    #     (Raylib.get_screen_height - my_flat_texture.height),
    #     Raylib::WHITE
    #   )
    #
    #   Raylib.end_drawing
    # end
    #
    # Raylib.close_window
    # ```
    module G_UsingWithRaylib
    end
  end
end
