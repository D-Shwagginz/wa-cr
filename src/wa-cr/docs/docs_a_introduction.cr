module A_Overview
  # # Where's all the Crystal? | wa-cr
  #
  # wa-cr, or "Where's all the Crystal?," is a Crystal library used to read in and write
  # out [.WAD](https://doomwiki.org/wiki/WAD) files and [Lump](https://doomwiki.org/wiki/Lump) data.<br>
  # It uses the `WritingAdditions` module to allow for writing lump and wad data.<br>
  # It also has the `RaylibAdditions` module which combines [Raylib](https://github.com/raysan5/raylib/tree/master)
  # and [Raylib-cr](https://github.com/sol-vin/raylib-cr) to allow converting from a wad graphic, flat, or sprite to
  # a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
  # or a [Raylib Color](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
  #
  # Reading in and writing out a wad is as easy:
  # ```
  # require "wa-cr"
  # require "wa-cr/write"
  #
  # my_wad = WAD.read("Path/To/Wad")
  #
  # my_wad.write("Path/To/my_wad.WAD")
  # ```
  #
  # Reading in and writing out a lump is just as easy:
  #
  # ```
  # require "wa-cr"
  # require "wa-cr/write"
  #
  # my_sound_lump = WAD::Sounds.parse("Path/To/MySound.lmp")
  #
  # my_sound_lump.write("Path/To/my_sound.lmp")
  # ```
  #
  # And you can read that lump back into a new `WAD` with `WAD#add(name, type, filename)`:
  #
  # ```
  # require "wa-cr"
  #
  # # When creating a new WAD, you have to set it's type (Internal or Patch)
  # my_new_wad = WAD.new(WAD::Type::Internal)
  #
  # my_new_wad.add("MySound", "Sound", "Path/To/my_sound.lmp")
  # ```
  #
  # To use the Raylib additions, just require `wa-cr/raylib`:
  #
  # ```
  # require "wa-cr"
  # require "wa-cr/raylib"
  #
  # my_wad = WAD.read("Path/To/Wad")
  # palette = my_wad.playpal.palettes[0]
  #
  # my_texture = my_wad.get_texture("MyTexture", palette)
  #
  # my_graphic = my_wad.graphics["MyGraphic"]
  # my_flat = my_wad.flats["MyFlat"]
  #
  # my_raylib_graphic_image = my_graphic.to_image(palette)
  # my_raylib_graphic_pixel = my_graphic.get_pixel(0, 0)
  #
  # my_raylib_flat_image = my_flat.to_image(palette)
  # my_raylib_flat_pixel = my_flat.get_pixel(0, 0)
  # ```
  module A_Introduction
  end
end
