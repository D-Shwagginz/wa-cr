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
    # ```
    # 
    # ```
    module H_UsingWithRaylib
    end
  end
end
