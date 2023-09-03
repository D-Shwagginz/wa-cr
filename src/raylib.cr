require "raylib-cr"
require "./wa-cr/**"

# The actual methods

# Additions to help wa-cr with graphical conversions using Raylib
module RaylibAdditions
  # Reads and stores the data of a WAD file.
  module WAD
    # Gets a texture as a raylib image given the texture name and a palette
    #
    # Example: Takes the name of a texture from TextureX and a palette
    # and converts the texture to a Raylib Image and draws that image.
    # ```
    # require "wa-cr/raylib"
    # palette = mywad.playpal.palettes[0]
    # my_image = mywad.get_texture("STARTAN3", palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def get_texture(name : String, palette : ::WAD::Playpal::Palette) : Raylib::Image
      texmaps.each do |texmapx|
        if texturemap = texmapx[1].mtextures.find { |m| m.name == name }
          if texturemap.name == name
            image = Raylib.gen_image_color(texturemap.width, texturemap.height, Raylib::BLANK)

            texturemap.patches.each do |texmap_patch|
              patch_name = pnames.patches[texmap_patch.patch]
              patch_image = graphics[patch_name.upcase.gsub("\u0000", "")].to_tex(palette)
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
  end

  # A WAD graphic
  module WAD::Graphic
    # Converts a graphic to a raylib image using a palette
    #
    # Example: Converts a graphic to a Raylib Image given a palette
    # and draws that image.
    # ```
    # require "wa-cr/raylib"
    # palette = mywad.playpal.palettes[0]
    # my_image = mywad.graphics["HELP1"].to_tex(palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def to_tex(palette : ::WAD::Playpal::Palette) : Raylib::Image
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

    # Returns a Raylib Color for the pixel of a graphic
    #
    # Example: Gets the Raylib Color of the pixel [2, 4] and draws it
    # ```
    # require "wa-cr/raylib"
    # palette = mywad.playpal.palettes[0]
    # my_pixel = mywad.graphics["HELP1"].get_color(2, 4)
    # Raylib.draw_pixel(
    #   0,
    #   0,
    #   my_pixel
    # )
    # ```
    def get_color(x : Int, y : Int) : Raylib::Color
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
  end

  # A WAD flat
  module WAD::Flat
    # Converts a flat to a raylib image using a palette
    #
    # Example: Converts a flat to a Raylib Image given a palette
    # and draws that image.
    # ```
    # require "wa-cr/raylib"
    # palette = mywad.playpal.palettes[0]
    # my_image = mywad.flats["FLOOR0_1"].to_tex(palette)
    # Raylib.draw_texture(
    #   Raylib.load_texture_from_image(my_image),
    #   0,
    #   0,
    #   Raylib::WHITE
    # )
    # ```
    def to_tex(palette : ::WAD::Playpal::Palette) : Raylib::Image
      image = Raylib.gen_image_color(width, height, Raylib::BLANK)
      colors.each_with_index do |p, i|
        palette_r = palette.colors[p].r
        palette_g = palette.colors[p].g
        palette_b = palette.colors[p].b
        Raylib.image_draw_pixel(pointerof(image), i % width, (i / width).to_i, Raylib::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
      end
      image
    end

    # Returns a Raylib Color for the pixel of a flat
    #
    # Example: Gets the Raylib Color of the pixel [5, 2] and draws it
    # ```
    # require "wa-cr/raylib"
    # palette = mywad.playpal.palettes[0]
    # my_pixel = mywad.flat["FLOOR0_1"].get_color(5, 2)
    # Raylib.draw_pixel(
    #   0,
    #   0,
    #   my_pixel
    # )
    # ```
    def get_color(x : Int, y : Int) : Raylib::Color
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
  end
end

class WAD
  include RaylibAdditions::WAD
end

class WAD::Graphic
  include RaylibAdditions::WAD::Graphic
end

class WAD::Flat
  include RaylibAdditions::WAD::Flat
end
