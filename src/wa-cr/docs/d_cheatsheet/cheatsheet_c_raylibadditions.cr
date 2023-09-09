module Documentation
  module D_Cheatsheet
    # - Raylib: `RaylibAdditions` - The module housing all of the raylib methods
    #   - `RaylibAdditions::WAD#get_texture(name, palette)` - Gets a texture from a `WAD`'s
    #     texture map and creates a `Raylib::Image` by using the palette
    #   - `RaylibAdditions::WAD#export_texture(name, filename, palette)` - Exports a texture from the `WAD`'s
    #     texture map as a png by using the palette
    #   - `RaylibAdditions::GraphicClassMethods.from_png(filename, palette, offset)` - Imports a png as a `WAD::Graphic` given the palette and the offset
    #   - `RaylibAdditions::GraphicClassMethods.from_image(image, palette, offset)` - Converts a `Raylib::Image` to a `WAD::Graphic` given the palette and the offset
    #   - `RaylibAdditions::Graphic#to_image(palette)` - Converts a graphic to a `Raylib::Image` by using the palette
    #   - `RaylibAdditions::Graphic#get_pixel(x, y, palette)` - Gets a *Raylib::Color* at the graphic pixel *x*, *y*
    #   - `RaylibAdditions::Graphic#to_png(filename, palette)` - Exports the graphic to a png given the filename and palette
    #   - `RaylibAdditions::FlatClassMethods.from_png(filename, palette)` - Imports an opaque 64x64 png as a `WAD::Flat` given the palette
    #   - `RaylibAdditions::FlatClassMethods.from_image(image, palette)` - Converts an opaque 64x64 `Raylib::Image` to a `WAD::Flat` given the palette
    #   - `RaylibAdditions::Flat#to_image(palette)` - Converts a flat to a `Raylib::Image` by using the palette
    #   - `RaylibAdditions::Flat#get_pixel(x, y, palette)` - Gets a *Raylib::Color* at the flat pixel *x*, *y*
    #   - `RaylibAdditions::Flat#to_png(filename, palette)` - Exports the flat to a png given the filename and palette
    # - [Raylib](https://github.com/raysan5/raylib) - The Raylib github
    # - [Raylib-cr](https://github.com/sol-vin/raylib-cr) - The Crystal C-Bindings for Raylib
    module C_RaylibAdditions
    end
  end
end
