module Documentation
  module D_Cheatsheet
    # - Raylib: `RaylibAdditions` - The module housing all of the raylib methods
    #   - `RaylibAdditions::WAD#get_texture(name, palette)` - Gets a texture from a `WAD`'s<br>
    #     texture map and creates a `Raylib::Image` by using the palette
    #   - `RaylibAdditions::Graphic#to_image(palette)` - Converts a graphic to a `Raylib::Image` by using the palette
    #     - `RaylibAdditions::Graphic#get_pixel(x, y)` - Gets a *Raylib::Color* at the graphic pixel *x*, *y*
    #   - `RaylibAdditions::Flat#to_image(palette)` - Converts a flat to a `Raylib::Image` by using the palette
    #     - `RaylibAdditions::Flat#get_pixel(x, y)` - Gets a *Raylib::Color* at the flat pixel *x*, *y*
    # - [Raylib](https://github.com/raysan5/raylib) - The Raylib github
    # - [Raylib-cr](https://github.com/sol-vin/raylib-cr) - The Crystal C-Bindings for Raylib
    module C_RaylibAdditions
    end
  end
end
