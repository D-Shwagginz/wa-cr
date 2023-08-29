require "raylib-cr"
require "./wad-reader/**"

alias R = Raylib

class WAD::Graphic
  # Converts a graphic to a raylib image using a palette
  def to_tex(palette : Playpal::Palette) : R::Image
    image = R.gen_image_color(width, height, R::BLANK)
    columns.each do |column|
      column.posts.each do |post|
        post.row_column_data.each do |pixel|
          palette_r = palette.colors[pixel.pixel].r
          palette_g = palette.colors[pixel.pixel].g
          palette_b = palette.colors[pixel.pixel].b
          R.image_draw_pixel(pointerof(image), pixel.column, pixel.row, R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
        end
      end
    end
    image
  end

  def [](x, y) : R::Color
    raise "Out of bounds" if x > width || y > height
    columns.each do |column|
      column.posts.each do |post|
        post.row_column_data.each do |pixel|
          if pixel.row == y && pixel.column == x
            palette_r = palette.colors[pixel.pixel].r
            palette_g = palette.colors[pixel.pixel].g
            palette_b = palette.colors[pixel.pixel].b
            return R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
          end
        end
      end
    end
    raise "Pixel did not exist"
  end
end

class WAD::Flat
  # Converts a flat to a raylib image using a palette
  def to_tex(palette : Playpal::Palette) : R::Image
    image = R.gen_image_color(width, height, R::BLANK)
    height.times do |y|
      width.times do |x|
        palette_r = palette.colors[colors[x + y * height]].r
        palette_g = palette.colors[colors[x + y * height]].g
        palette_b = palette.colors[colors[x + y * height]].b
        R.image_draw_pixel(pointerof(image), x, y, R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255))
      end
    end
    image
  end

  def [](x, y) : R::Color
    raise "Out of bounds" if x > width || y > height
    height.each do |y|
      width.each do |x|
        if y == y && x == x
          palette_r = palette.colors[pixel.pixel].r
          palette_g = palette.colors[pixel.pixel].g
          palette_b = palette.colors[pixel.pixel].b
          return R::Color.new(r: palette_r, g: palette_g, b: palette_b, a: 255)
        end
      end
    end
    raise "Pixel did not exist"
  end
end
