require "raylib-cr"
require "./wad-reader/**"
require "./rcamera.cr"

alias R = Raylib
alias RM = Raymath
alias RC = Rcamera

class WAD
  # Gets a texture as a raylib image given the texture name and a palette
  def get_texture(name, palette : Playpal::Palette) : R::Image
    texmaps.each do |texmapx|
      if texturemap = texmapx[1].mtextures.find { |m| m.name == name }
        if texturemap.name == name
          image = R.gen_image_color(texturemap.width, texturemap.height, R::BLANK)

          texturemap.patches.each do |texmap_patch|
            patch_name = pnames.patches[texmap_patch.patch]
            patch_image = graphics[patch_name.upcase].to_tex(palette)
            R.image_draw(
              pointerof(image),
              patch_image,
              R::Rectangle.new(
                x: 0,
                y: 0,
                width: patch_image.width,
                height: patch_image.height
              ),
              R::Rectangle.new(
                x: texmap_patch.originx,
                y: texmap_patch.originy,
                width: patch_image.width,
                height: patch_image.height
              ), R::WHITE
            )
            R.unload_image(patch_image)
          end
          return image
        end
      end
    end
    return R.gen_image_color(64, 64, R::PURPLE)
  end
end

class WAD::Graphic
  # Converts a graphic to a raylib image using a palette
  def to_tex(palette : Playpal::Palette) : R::Image
    image = R.gen_image_color(width, height, R::BLANK)
    data.each_with_index do |p, i|
      next if p.nil?
      palette_r = palette.colors[p].r
      palette_g = palette.colors[p].g
      palette_b = palette.colors[p].b
      R.image_draw_pixel(pointerof(image), i % width, (i / width).to_i, R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
    end
    image
  end

  def get_color(x, y) : R::Color
    raise "Out of bounds" if x > width || y > height
    if pixel = self[x, y]
      palette_r = palette.colors[pixel].r
      palette_g = palette.colors[pixel].g
      palette_b = palette.colors[pixel].b
      return R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
    else
      return R::Color.new(r: 0, g: 0, b: 0, a: 0)
    end
  end
end

class WAD::Flat
  # Converts a flat to a raylib image using a palette
  def to_tex(palette : Playpal::Palette) : R::Image
    image = R.gen_image_color(width, height, R::BLANK)
    colors.each_with_index do |p, i|
      palette_r = palette.colors[p].r
      palette_g = palette.colors[p].g
      palette_b = palette.colors[p].b
      R.image_draw_pixel(pointerof(image), i % width, (i / width).to_i, R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
    end
    image
  end

  def get_color(x, y) : R::Color
    raise "Out of bounds" if x > width || y > height
    if pixel = self[x, y]
      palette_r = palette.colors[pixel].r
      palette_g = palette.colors[pixel].g
      palette_b = palette.colors[pixel].b
      return R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
    else
      return R::Color.new(r: 0, g: 0, b: 0, a: 0)
    end
  end
end
