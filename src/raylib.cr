require "raylib-cr"
require "./wad-reader/**"

alias R = Raylib

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
