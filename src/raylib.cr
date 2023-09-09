require "raylib-cr"
require "./wa-cr/**"

# ### Additions to help wa-cr with graphical conversions using [Raylib](https://github.com/raysan5/raylib/releases)
#
# To use these additions, just require it:
#
# ```
# require "wa-cr/raylib"
# ```
#
# Here's some examples of this addition:
#
# ```
# require "wa-cr/raylib"
#
# # Gets the palette to use for the images
# palette = myw_ad.playpal.palettes[0]
#
# my_wad.get_texture("NameOfTexture", palette) # => Raylib::Image
#
# my_graphic.to_image(palette) # => Raylib::Image
#
# # You can also get pixel data from the image
# my_graphic.get_pixel(x, y, palette) # => Raylib::Color
#
# my_flat.to_image(palette) # => Raylib::Image
#
# my_flat.get_pixel(x, y, palette) # => Raylib::Color
# ```
module RaylibAdditions
  # Reads and stores the data of a WAD file.
  module WAD
    # Gets a texture as a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
    # given the texture name and a palette
    #
    # Takes the name of a texture from TextureX and a palette
    # and converts the texture to a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251)
    # and draws that image:
    # ```
    # require "wa-cr/raylib"
    # palette = my_wad.playpal.palettes[0]
    # my_image = my_wad.get_texture("STARTAN3", palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def get_texture(name : String, palette : ::WAD::Playpal::Palette) : Raylib::Image
      texmaps.values.each do |texmapx|
        if texturemap = texmapx.mtextures.find { |m| m.name == name }
          if texturemap.name == name
            image = Raylib.gen_image_color(texturemap.width, texturemap.height, Raylib::BLANK)

            texturemap.patches.each do |texmap_patch|
              patch_name = pnames.patches[texmap_patch.patch]
              patch_image = graphics[patch_name.upcase.gsub("\u0000", "")].to_image(palette)
              Raylib.image_draw(
                pointerof(image),
                patch_image,
                Raylib::Rectangle.new(
                  x: 0,
                  y: 0,
                  width: patch_image.width,
                  height: patch_image.height
                ),
                Raylib::Rectangle.new(
                  x: texmap_patch.originx,
                  y: texmap_patch.originy,
                  width: patch_image.width,
                  height: patch_image.height
                ), Raylib::WHITE
              )
              Raylib.unload_image(patch_image)
            end
            return image
          end
        end
      end
      return Raylib.gen_image_color(64, 64, Raylib::PURPLE)
    end

    # Exports a texture to a png given a *texture_name*, a *filename*, and a *palette*
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_wad.export_texture("MyTexture", "Path/To/MyGraphic.png", palette)
    # ```
    def export_texture(texture_name : String, filename : String | Path, palette : ::WAD::Playpal::Palette)
      filename = filename.to_s
      filename = filename + ".png" if filename[filename.rindex!('.'), filename.size - 1] != ".png"
      image = self.get_texture(texture_name, palette)
      Raylib.export_image?(image, filename)
      Raylib.unload_image(image)
    end
  end

  # A WAD graphic
  module Graphic
    # Converts a graphic to a raylib image using a palette
    #
    # Converts a graphic to a Raylib Image given a palette
    # and draws that image:
    # ```
    # require "wa-cr/raylib"
    # palette = my_wad.playpal.palettes[0]
    # my_image = my_wad.graphics["HELP1"].to_image(palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def to_image(palette : ::WAD::Playpal::Palette) : Raylib::Image
      image = Raylib.gen_image_color(width, height, Raylib::BLANK)
      data.each_with_index do |p, i|
        next if p.nil?
        palette_r = palette.colors[p].r
        palette_g = palette.colors[p].g
        palette_b = palette.colors[p].b
        Raylib.image_draw_pixel(pointerof(image), i % width, (i / width).to_i, Raylib::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
      end
      image
    end

    # Returns a [Raylib Color](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # for the pixel of a graphic
    #
    # Gets the [Raylib Color](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # of the pixel [2, 4] and draws it:
    # ```
    # require "wa-cr/raylib"
    # palette = my_wad.playpal.palettes[0]
    # my_pixel = my_wad.graphics["HELP1"].get_pixel(2, 4)
    # Raylib.draw_pixel(
    #   0,
    #   0,
    #   my_pixel
    # )
    # ```
    def get_pixel(x : Int, y : Int, palette : ::WAD::Playpal::Palette) : Raylib::Color
      raise "Out of bounds" if x > width || y > height
      if pixel = self[x, y]
        palette_r = palette.colors[pixel].r
        palette_g = palette.colors[pixel].g
        palette_b = palette.colors[pixel].b
        return Raylib::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
      else
        return Raylib::Color.new(r: 0, g: 0, b: 0, a: 0)
      end
    end

    # Exports a graphic to a png given a *filename* and a *palette*
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_graphic = my_wad.graphics["MyGraphic"]
    #
    # my_graphic.to_png("Path/To/MyGraphic.png", palette)
    # ```
    def to_png(filename : String | Path, palette : ::WAD::Playpal::Palette)
      filename = filename.to_s
      filename = filename + ".png" if filename[filename.rindex!('.'), filename.size - 1] != ".png"
      image = self.to_image(palette)
      Raylib.export_image?(image, filename)
      Raylib.unload_image(image)
    end
  end

  # Raylib class methods for `WAD::Graphic`
  module GraphicClassMethods
    # Gets the absolute [Color Distance](https://en.wikipedia.org/wiki/Color_difference) between *color1* to *color*2
    def color_distance(color1 : Raylib::Color, color2 : Raylib::Color) : Int
      return (((color1.r.to_i - color2.r.to_i)**2) +
        ((color1.g.to_i - color2.g.to_i)**2) +
        ((color1.b.to_i - color2.b.to_i)**2)).abs
    end

    # Converts a .png to a `WAD::Graphic` given the *filename*, the *palette*, and the *offset*
    #
    # NOTE: If you get an arithmetic overflow error at any point, chances are that your image is too big
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_png_graphic = WAD::Graphic.from_png("Path/To/MyGraphic.png", palette, WAD::Graphic::Offsets::BottomCenter)
    # ```
    def from_png(filename : String | Path, palette : ::WAD::Playpal::Palette, offset : ::WAD::Graphic::Offsets = ::WAD::Graphic::Offsets::TopLeft) : ::WAD::Graphic
      filename = filename.to_s
      filename = filename + ".png" if filename[filename.rindex!('.'), filename.size - 1] != ".png"
      image = Raylib.load_image(filename)
      graphic = from_image(image, palette, offset)
      Raylib.unload_image(image)
      return graphic
    end

    # Converts a `Raylib::Image` to a `WAD::Graphic` given the *filename*, the *palette*, and the *offset*
    #
    # NOTE: If you get an arithmetic overflow error at any point, chances are that your image is too big
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_image = Raylib.gen_image_color(100, 80, Raylib::RED)
    #
    # my_image_graphic = WAD::Graphic.from_image(my_image, palette, WAD::Graphic::Offsets::BottomCenter)
    # ```
    def from_image(image : Raylib::Image, palette : ::WAD::Playpal::Palette, offset : ::WAD::Graphic::Offsets = ::WAD::Graphic::Offsets::TopLeft) : ::WAD::Graphic
      offsets = [
        [0_i16, 0_i16],
        [0_i16, (image.width//2).to_i16],
        [0_i16, image.width.to_i16],
        [(image.height//2).to_i16, 0_i16],
        [(image.height//2).to_i16, (image.width//2).to_i16],
        [(image.height//2).to_i16, image.width.to_i16],
        [image.height.to_i16, 0_i16],
        [image.height.to_i16, (image.width//2).to_i16],
        [image.height.to_i16, image.width.to_i16],
      ]
      # A tuple of the color, the index in the palette, and the distance to the current palette color
      current_closest_color : Tuple(Raylib::Color, UInt8, Int32) = {Raylib::BLACK, 0_u8, 0}
      graphic = ::WAD::Graphic.new

      graphic.topoffset = offsets[offset.value][0]
      graphic.leftoffset = offsets[offset.value][1]

      graphic.width = image.width.to_u16
      graphic.height = image.height.to_u16
      graphic.reset_data

      image.height.times do |y|
        image.width.times do |x|
          current_image_color = Raylib.get_image_color(image, x, y)

          if current_image_color.a != 0
            raylib_palette_color = Raylib::Color.new(
              r: palette.colors[0].r, g: palette.colors[0].g, b: palette.colors[0].b, a: 255
            )

            current_closest_color = {raylib_palette_color, 0_u8, color_distance(current_image_color, raylib_palette_color)}

            palette.colors.each.with_index do |color, index|
              raylib_palette_color = Raylib::Color.new(r: color.r, g: color.g, b: color.b, a: 255)
              if (current_distance = color_distance(current_image_color, raylib_palette_color)) < current_closest_color[2]
                current_closest_color = {raylib_palette_color, index.to_u8, current_distance}
              end
            end

            graphic.data[x + y * graphic.width] = current_closest_color[1]
          end
        end
      end

      return graphic
    end
  end

  # A WAD flat
  module Flat
    # Converts a flat to a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251) using a palette
    #
    # Converts a flat to a [Raylib Image](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L251) given a palette:
    # and draws that image.
    # ```
    # require "wa-cr/raylib"
    # palette = my_wad.playpal.palettes[0]
    # my_image = my_wad.flats["FLOOR0_1"].to_image(palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def to_image(palette : ::WAD::Playpal::Palette) : Raylib::Image
      image = Raylib.gen_image_color(width, height, Raylib::BLANK)
      colors.each_with_index do |p, i|
        palette_r = palette.colors[p].r
        palette_g = palette.colors[p].g
        palette_b = palette.colors[p].b
        Raylib.image_draw_pixel(pointerof(image), i % width, (i / width).to_i, Raylib::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
      end
      image
    end

    # Returns a [Raylib Color](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # for the pixel of a flat
    #
    # Gets the [Raylib Color](https://github.com/raysan5/raylib/blob/c147ab51c92abb09af5a5bc93759c7d360b8e1be/src/raylib.h#L235C6-L235C6)
    # of the pixel [5, 2] and draws it:
    # ```
    # require "wa-cr/raylib"
    # palette = my_wad.playpal.palettes[0]
    # my_pixel = my_wad.flats["FLOOR0_1"].get_pixel(5, 2)
    # Raylib.draw_pixel(
    #   0,
    #   0,
    #   my_pixel
    # )
    # ```
    def get_pixel(x : Int, y : Int, palette : ::WAD::Playpal::Palette) : Raylib::Color
      raise "Out of bounds" if x > width || y > height
      if pixel = self[x, y]
        palette_r = palette.colors[pixel].r
        palette_g = palette.colors[pixel].g
        palette_b = palette.colors[pixel].b
        return Raylib::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
      else
        return Raylib::Color.new(r: 0, g: 0, b: 0, a: 0)
      end
    end

    # Exports a flat to a png given a *filename* and a *palette*
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_flat = my_wad.flats["MyFlat"]
    #
    # my_flat.to_png("Path/To/MyFlat.png", palette)
    # ```
    def to_png(filename : String | Path, palette : ::WAD::Playpal::Palette)
      filename = filename.to_s
      filename = filename + ".png" if filename[filename.rindex!('.'), filename.size - 1] != ".png"
      image = self.to_image(palette)
      Raylib.export_image?(image, filename)
      Raylib.unload_image(image)
    end
  end

  # Raylib class methods for `WAD::Flat`
  module FlatClassMethods
    # Gets the absolute [Color Distance](https://en.wikipedia.org/wiki/Color_difference) between *color1* to *color*2
    def color_distance(color1 : Raylib::Color, color2 : Raylib::Color) : Int
      return (((color1.r.to_i - color2.r.to_i)**2) +
        ((color1.g.to_i - color2.g.to_i)**2) +
        ((color1.b.to_i - color2.b.to_i)**2)).abs
    end

    # Converts a .png to a `WAD::Flat` given the *filename* and the *palette*
    #
    # NOTE: The png has to be 64x64 and have no transparent pixels
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_png_flat = WAD::Flat.from_png("Path/To/MyFlat.png", palette)
    # ```
    def from_png(filename : String | Path, palette : ::WAD::Playpal::Palette) : ::WAD::Flat
      filename = filename.to_s
      filename = filename + ".png" if filename[filename.rindex!('.'), filename.size - 1] != ".png"
      image = Raylib.load_image(filename)
      flat = from_image(image, palette)
      Raylib.unload_image(image)
      return flat
    end

    # Converts a `Raylib::Image` to a `WAD::Flat` given the *image* and the *palette*
    #
    # NOTE: The image has to be 64x64 and have no transparent pixels
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # palette = my_wad.playpal.palettes[0]
    #
    # my_image = Raylib.gen_image_color(64, 64, Raylib::RED)
    #
    # my_image_flat = WAD::Flat.from_image(my_image, palette)
    # ```
    def from_image(image : Raylib::Image, palette : ::WAD::Playpal::Palette) : ::WAD::Flat
      if image.width != 64 || image.height != 64
        raise "A FLAT NEEDS TO BE 64x64. *image* IS #{image.width}x#{image.height}"
      end

      # A tuple of the color, the index in the palette, and the distance to the current palette color
      current_closest_color : Tuple(Raylib::Color, UInt8, Int32) = {Raylib::BLACK, 0_u8, 0}
      flat = ::WAD::Flat.new

      image.height.times do |y|
        image.width.times do |x|
          current_image_color = Raylib.get_image_color(image, x, y)

          if current_image_color.a != 0
            raylib_palette_color = Raylib::Color.new(
              r: palette.colors[0].r, g: palette.colors[0].g, b: palette.colors[0].b, a: 255
            )

            current_closest_color = {raylib_palette_color, 0_u8, color_distance(current_image_color, raylib_palette_color)}

            palette.colors.each.with_index do |color, index|
              raylib_palette_color = Raylib::Color.new(r: color.r, g: color.g, b: color.b, a: 255)
              if (current_distance = color_distance(current_image_color, raylib_palette_color)) < current_closest_color[2]
                current_closest_color = {raylib_palette_color, index.to_u8, current_distance}
              end
            end

            flat.colors << current_closest_color[1]
          else
            raise "Pixel x: #{x}, y: #{y} is transparent. Flats can not have transparent pixels"
          end
        end
      end

      return flat
    end
  end
end

class WAD
  include RaylibAdditions::WAD
end

class WAD::Graphic
  include RaylibAdditions::Graphic
  extend RaylibAdditions::GraphicClassMethods
end

class WAD::Flat
  include RaylibAdditions::Flat
  extend RaylibAdditions::FlatClassMethods
end
