module Documentation
  module C_Usage
    # ### `WAD::Sound` to .wav
    #
    # To convert a `WAD::Sound` to a [WAV](https://en.wikipedia.org/wiki/WAV),
    # use `WAD::Sound#to_wav(file : String | Path | IO)`:
    #
    # ```
    # my_sound.to_wav("Path/To/MySound.wav")
    # ```
    #
    # ### .wav to `WAD::Sound`
    #
    # To convert a [WAV](https://en.wikipedia.org/wiki/WAV) to a `WAD::Sound`,
    # use `WAD::Sound.from_wav(file : String | Path | IO)`:
    #
    # ```
    # my_wav_sound = WAD::Sound.from_wav("Path/To/Sound.wav")
    # ```
    #
    # ## The following convertion methods use `RaylibAdditions`
    #
    # ### `WAD` texture to .png
    #
    # To convert a `WAD` texture to a [PNG](https://en.wikipedia.org/wiki/PNG),
    # you'll need to require `wa-cr/raylib` and use the `RaylibAdditions`
    # method `RaylibAdditions::WAD#export_texture(texture_name, filename, palette)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    # palette = my_wad.playpal.palettes[0]
    #
    # my_wad.export_texture("MyTexture", "Path/To/MyTexture.png", palette)
    # ```
    #
    # ### `WAD::Graphic` to .png
    #
    # To convert a `WAD::Graphic` to a [PNG](https://en.wikipedia.org/wiki/PNG),
    # you'll need to require `wa-cr/raylib` and use the `RaylibAdditions`
    # method `RaylibAdditions::Graphic#to_png(filename, palette)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    # palette = my_wad.playpal.palettes[0]
    #
    # my_graphic = my_wad.graphics["MyGraphic"]
    #
    # my_graphic.to_png("Path/To/MyGraphic.png", palette)
    # ```
    #
    # ### .png to `WAD::Graphic`
    #
    # To convert a [PNG](https://en.wikipedia.org/wiki/PNG)
    # to a `WAD::Graphic`, you'll need to require `wa-cr/raylib`
    # and use the `RaylibAdditions` method `RaylibAdditions::GraphicClassMethods.from_png(filename, palette, offset)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_graphic = WAD::Graphic.from_png("Path/To/MyGraphic.png", palette)
    #
    # # You can set the offset/origin of the image as well.
    # # For most sprites, the origin will be the bottom center.
    # # The default offset is `WAD::Graphic::Offsets::TopLeft`
    # my_sprite = WAD::Graphic.from_png("Path/To/MySprite.png", palette, WAD::Graphic::Offsets::BottomCenter)
    #
    # my_wad.graphics["MyGraphic"] = my_graphic
    # my_wad.new_dir("MyGraphic")
    #
    # my_wad.sprites["MySprite"] = my_sprite
    # my_wad.new_dir("MySprite")
    # ```
    #
    # ### `Raylib::Image` to `WAD::Graphic`
    #
    # To convert a `Raylib::Image` to a `WAD::Graphic`, you'll need to require `wa-cr/raylib`
    # and use the `RaylibAdditions` method `RaylibAdditions::GraphicClassMethods.from_image(image, palette, offset)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_image = Raylib.gen_image_color(180, 20, Raylib::WHITE)
    #
    # my_graphic = WAD::Graphic.from_image(my_image, palette)
    #
    # # You can set the offset/origin of the image as well.
    # # For most sprites, the origin will be the bottom center.
    # # The default offset is `WAD::Graphic::Offsets::TopLeft`
    # my_sprite = WAD::Graphic.from_image(my_image, palette, WAD::Graphic::Offsets::BottomCenter)
    #
    # my_wad.graphics["MyGraphic"] = my_graphic
    # my_wad.new_dir("MyGraphic")
    #
    # my_wad.sprites["MySprite"] = my_sprite
    # my_wad.new_dir("MySprite")
    # ```
    #
    # ### `WAD::Flat` to .png
    #
    # To convert a `WAD::Flat` to a [PNG](https://en.wikipedia.org/wiki/PNG),
    # you'll need to require `wa-cr/raylib` and use the `RaylibAdditions`
    # method `RaylibAdditions::Flat#to_png(filename, palette)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    # palette = my_wad.playpal.palettes[0]
    #
    # my_flat = my_wad.flats["MyFlat"]
    #
    # my_flat.to_png("Path/To/MyFlat.png", palette)
    # ```
    #
    # ### .png to `WAD::Flat`
    #
    # To convert an opaque 64x64 [PNG](https://en.wikipedia.org/wiki/PNG)
    # to a `WAD::Flat`, you'll need to require `wa-cr/raylib`
    # and use the `RaylibAdditions` mthod `RaylibAdditions::FlatClassMethods.from_png(filename, palette)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_flat = WAD::Flat.from_png("Path/To/MyFlat.png", palette)
    #
    # my_wad.flats["MyFlat"] = my_flat
    # my_wad.new_dir("MyFlat")
    # ```
    #
    # ### `Raylib::Image` to `WAD::Flat`
    #
    # To convert an opaque 64x64 `Raylib::Image` to a
    # `WAD::Flat`, you'll need to require `wa-cr/raylib`
    # and use the `RaylibAdditions` mthod `RaylibAdditions::FlatClassMethods.from_image(image, palette)`:
    #
    # ```
    # require "wa-cr/raylib"
    #
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_image = Raylib.gen_image_color(100, 40, Raylib::BLUE)
    #
    # my_flat = WAD::Flat.from_image(my_image, palette)
    #
    # my_wad.flats["MyFlat"] = my_flat
    # my_wad.new_dir("MyFlat")
    # ```
    module E_ConvertingFileTypes
    end
  end
end
