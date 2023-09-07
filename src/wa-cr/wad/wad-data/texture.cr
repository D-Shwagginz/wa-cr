class WAD
  # Color palettes for various situations.
  class Playpal
    property palettes : Array(Palette) = [] of Palette

    # A color palette
    class Palette
      property colors : Array(Color) = [] of Color
    end

    # A color
    struct Color
      property r : UInt8 = 0_u8
      property g : UInt8 = 0_u8
      property b : UInt8 = 0_u8
    end

    # Parses a playpal file given the filename
    #
    # Opens a playpal file and parses it:
    # ```
    # my_playpal = WAD::Playpal.parse("Path/To/Playpal")
    # ```
    def self.parse(filename : String | Path) : Playpal
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Playpal invalid"
    end

    # Parses a playpal file given the io
    #
    # Opens a playpal io and parses it:
    # ```
    # File.open("Path/To/Playpal") do |file|
    #   my_playpal = WAD::Playpal.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Playpal
      playpal = Playpal.new
      colors_per_palette = 256
      amount_of_palettes = 14

      amount_of_palettes.times do
        palette = Palette.new
        (colors_per_palette).to_i.times do
          color = Color.new
          color.r = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.g = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.b = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          palette.colors << color
        end
        playpal.palettes << palette
      end
      playpal
    end

    # Checks to see if *name* is "PLAYPAL"
    #
    # Returns true if the name is a playpal:
    # ```
    # playpal_name = "PLAYPAL"
    # if WAD::Playpal.is_playpal?(playpal_name)
    #   puts "Is a Playpal"
    # else
    #   puts "Is not a Playpal"
    # end
    # ```
    def self.is_playpal?(name : String)
      !!(name =~ /^PLAYPAL/)
    end
  end

  # Map to adjust pixel values for reduced brightness.
  class Colormap
    property tables : Array(Table) = [] of Table

    # A colormap containing it's table's data
    class Table
      property table : Array(UInt8) = [] of UInt8
    end

    # Parses a colormap file given the filename
    #
    # Opens a colormap file and parses it:
    # ```
    # my_colormap = WAD::Colormap.parse("Path/To/Colormap")
    # ```
    def self.parse(filename : String | Path) : Colormap
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Colormap invalid"
    end

    # Parses a colormap file given the io
    #
    # Opens a colormap io and parses it:
    # ```
    # File.open("Path/To/Colormap") do |file|
    #   my_colormap = WAD::Colormap.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Colormap
      colormap = Colormap.new
      amount_of_tables = 34
      length_of_table = 256

      amount_of_tables.times do
        table = Table.new
        length_of_table.times do
          table.table << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        end
        colormap.tables << table
      end
      colormap
    end

    # Checks to see if *name* is "COLORMAP"
    #
    # Returns true if the name is a colormap:
    # ```
    # colormap_name = "COLORMAP"
    # if WAD::Colormap.is_colormap?(genmidi_name)
    #   puts "Is a ColorMap"
    # else
    #   puts "Is not a ColorMap"
    # end
    # ```
    def self.is_colormap?(name : String)
      !!(name =~ /^COLORMAP/)
    end
  end

  # The colorful screen shown when Doom exits.
  class EnDoom
    # An array of all the characters in the EnDoom
    property characters : Array(EnDoomChars) = [] of EnDoomChars

    # A character in the EnDoom
    struct EnDoomChars
      # The character's ascii value
      property ascii_value : UInt8 = 0_u8
      # The character's color
      property color : UInt8 = 0_u8
    end

    # Parses a endoom file given the filename
    #
    # Opens a endoom file and parses it:
    # ```
    # my_endoom = WAD::EnDoom.parse("Path/To/EnDoom")
    # ```
    def self.parse(filename : String | Path) : EnDoom
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "EnDoom invalid"
    end

    # Parses a endoom file given the io
    #
    # Opens a endoom io and parses it:
    # ```
    # File.open("Path/To/EnDoom") do |file|
    #   my_endoom = WAD::EnDoom.parse(file)
    # end
    # ```
    def self.parse(io : IO) : EnDoom
      endoom = EnDoom.new
      num_of_chars = 2000

      num_of_chars.times do
        endoomchar = EnDoomChars.new

        endoomchar.ascii_value = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        endoomchar.color = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

        endoom.characters << endoomchar
      end
      endoom
    end

    # Checks to see if *name* is "ENDDOOM"
    #
    # Returns true if the name is a endoom:
    # ```
    # endoom_name = "ENDOOM"
    # if WAD::EnDoom.is_endoom?(endoom_name)
    #   puts "Is a EnDoom"
    # else
    #   puts "Is not a EnDoom"
    # end
    # ```
    def self.is_endoom?(name : String)
      !!(name =~ /^ENDOOM/)
    end
  end

  # Defines how wall patches from the WAD file should combine to form wall textures.
  class TextureX
    property numtextures : Int32 = 0_i32
    property offsets : Array(Int32) = [] of Int32
    property mtextures : Array(TextureMap) = [] of TextureMap

    # "The binary contents of the maptexture_t structure starts with a header of 22 bytes, followed by all the map patches."
    class TextureMap
      property name : String = ""
      property masked : Bool = false
      property width : Int16 = 0_i16
      property height : Int16 = 0_i16
      property columndirectory : Int32 = 0_i32
      property patchcount : Int16 = 0_i16
      property patches : Array(Patch) = [] of Patch
    end

    # "The binary contents of the mappatch_t structure contains 10 bytes defining how the patch should be drawn inside the texture."
    struct Patch
      property originx : Int16 = 0_i16
      property originy : Int16 = 0_i16
      property patch : Int16 = 0_i16
      property stepdir : Int16 = 0_i16
      property colormap : Int16 = 0_i16
    end

    # Parses a texture map file given the filename
    #
    # Opens a texture map file and parses it:
    # ```
    # my_texturemap = WAD::TextureX.parse("Path/To/TextureMap")
    # ```
    def self.parse(filename : String | Path) : TextureX
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Texture map invalid"
    end

    # Parses a texture map file given the io
    #
    # Opens a texture map io and parses it:
    # ```
    # File.open("Path/To/TextureMap") do |file|
    #   my_texturemap = WAD::TextureX.parse(file)
    # end
    # ```
    def self.parse(io : IO) : TextureX
      texturex = TextureX.new
      texturex.numtextures = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)

      # Reads the offset to the map textures
      texturex.numtextures.times do
        texturex.offsets << io.read_bytes(Int32, IO::ByteFormat::LittleEndian)
      end

      texturex.offsets.each do
        texturemap = TextureMap.new
        texturemap.name = io.gets(8).to_s
        texturemap.masked = io.read_bytes(Int32, IO::ByteFormat::LittleEndian) != 0
        texturemap.width = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        texturemap.height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        texturemap.columndirectory = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)
        texturemap.patchcount = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        texturemap.patchcount.times do
          patch = Patch.new

          patch.originx = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          patch.originy = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          patch.patch = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          patch.stepdir = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          patch.colormap = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          texturemap.patches << patch
        end
        texturex.mtextures << texturemap
      end
      texturex
    end

    # Checks to see if *name* is "TEXTUREx"
    #
    # Returns true if the name is a texture map:
    # ```
    # texturemap_name = "TEXTURE1"
    # if WAD::TextureX.is_texturex?(texturemap_name)
    #   puts "Is a Texture Map"
    # else
    #   puts "Is not a Texture Map"
    # end
    # ```
    def self.is_texturex?(name : String)
      !!(name =~ /^TEXTURE\d/)
    end
  end

  # Includes all the names for wall patches.
  class Pnames
    property num_patches : Int32 = 0_i32
    property patches : Array(String) = [] of String

    # Parses a pnames file given the filename
    #
    # Example: Opens a pnames file and parses it
    # ```
    # my_pnames = WAD::Pnames.parse("Path/To/Pnames")
    # ```
    def self.parse(filename : String | Path) : Pnames
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Pnames invalid"
    end

    # Parses a pnames file given the io
    #
    # Example: Opens a pnames io and parses it
    # ```
    # File.open("Path/To/Pnames") do |file|
    #   my_pnames = WAD::Pnames.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Pnames
      pnames = Pnames.new

      pnames.num_patches = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)

      pnames.num_patches.times do
        pnames.patches << io.gets(8).to_s
      end
      pnames
    end

    # Checks to see if *name* is "PNAMES"
    #
    # Example: Returns true if the name is a pnames
    # ```
    # pnames_name = "PNAMES"
    # if WAD::Pnames.is_pnames?(pnames_name)
    #   puts "Is a Pnames"
    # else
    #   puts "Is not a Pnames"
    # end
    # ```
    def self.is_pnames?(name : String)
      !!(name =~ /^PNAMES/)
    end
  end

  # :nodoc:
  # A class used as a middle man for parsing a doom graphic
  class GraphicParse
    property columnoffsets : Array(UInt32) = [] of UInt32
    property columns : Array(Column) = [] of Column

    class Column
      property posts : Array(Post) = [] of Post
    end

    # A column of pixel data
    class Post
      property topdelta : UInt8 = 0_u8
      property length : UInt8 = 0_u8
      property data : Array(UInt8) = [] of UInt8
      property row_column_data : Array(RowColumnPixel) = [] of RowColumnPixel
    end

    struct RowColumnPixel
      property pixel : UInt8 = 0_u8
      property row : UInt32 = 0_u32
      property column : UInt32 = 0_u32
    end
  end

  # A WAD graphic
  #
  # NOTE: Graphic has no `is_graphic?` method.
  # Instead, `Graphic#parse` will return `nil` if
  # *io* is not a valid graphic
  class Graphic
    property width : UInt16 = 0_u16
    property height : UInt16 = 0_u16
    property leftoffset : Int16 = 0_i16
    property topoffset : Int16 = 0_i16
    property file_size : UInt32 = 0_u32

    getter data : Array(UInt8?) = [] of UInt8?

    # Sets a pixel in the graphic to be *value*.
    # Raises an error if value is not within the bounds
    # of a `UInt8`
    #
    # NOTE: *value* does not refer to an rgb color,
    # but instead to an index in the colors of a `WAD::Playpal::Palette`
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # my_graphic = my_wad.graphics["MyGraphic"]
    #
    # my_graphic[2, 3] # => Returns the value of the pixel at x=2 y=3
    #
    # my_graphic.set_pixel(2, 3, 120) # => Sets the value of the pixel at x=2 y=3 to be 120
    #
    # my_graphic[2, 3] # => 120
    #
    # my_graphic.set_pixel(2, 3, -1) # => Raises an exception
    #
    # my_graphic.set_pixel(2, 3, 256) # => Raises an exception
    # ```
    def set_pixel(x : Int, y : Int, value : Int)
      raise "Out of bounds" if x > width || y > height
      if self[x, y]
        begin
          data[x + y * width] = value.to_u8
        rescue e : OverflowError
          raise "'#{value}' IS NOT WITHIN THE BOUNDS OF A UInt8"
        end
      end
    end

    def [](x : Int, y : Int)
      data[x + y * width]
    end

    def reset_data
      (width*height).times do
        @data << nil
      end
    end

    # Parses a graphic file given the filename
    #
    # Opens a graphic file and parses it:
    # ```
    # my_graphic = WAD::Graphic.parse("Path/To/Graphic")
    # ```
    def self.parse(filename : String | Path) : Graphic | Nil
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Graphic invalid"
    end

    # Parses a graphic file given the file
    #
    # Opens a graphic file and parses it:
    # ```
    # File.open("Path/To/Graphic") do |file|
    #   my_graphic = WAD::Graphic.parse(file)
    # end
    # ```
    def self.parse(file : File, file_pos : Int = 0, size : Int = -1) : Graphic | Nil
      begin
        size = file.size if size < 0
        graphic_parse = GraphicParse.new
        graphic = Graphic.new
        file.read_at(file_pos, size) do |g_io|
          graphic.width = g_io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          graphic.height = g_io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          graphic.leftoffset = g_io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          graphic.topoffset = g_io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          graphic.width.times do
            graphic_parse.columnoffsets << g_io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
          end

          graphic.file_size += (graphic.width*4) + 8

          graphic.width.times do |i|
            file.read_at(file_pos + graphic_parse.columnoffsets[i], size - graphic_parse.columnoffsets[i]) do |c_io|
              rowstart = 0
              column = GraphicParse::Column.new

              loop do
                rowstart = c_io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                post = GraphicParse::Post.new
                post.topdelta = rowstart
                if rowstart == 255
                  graphic.file_size += 1
                  break
                end

                post.length = c_io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                graphic.file_size += post.length.to_u32 + 4.to_u32
                dummy = c_io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

                # post.length.times do |j|
                #   pixel = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                #   post.data << pixel
                #   row_column_pixel = RowColumnPixel.new
                #   row_column_pixel.pixel = pixel
                #   row_column_pixel.row = j + rowstart
                #   row_column_pixel.column = i
                # end
                # column.posts << post

                pixel_parse(i, column, post, c_io)
                dummy = c_io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
              end

              graphic_parse.columns << column

              if graphic_parse.columns.size == graphic.width
                begin
                  while (graphic.file_size < size) && (i = c_io.read_bytes(UInt8, IO::ByteFormat::LittleEndian))
                    if i != 0
                      break
                    end
                    graphic.file_size += 1
                  end
                rescue e : IO::EOFError
                end
              end
            end
          end
        end

        if size == graphic.file_size
          graphic.reset_data
          graphic_parse.columns.each do |column|
            column.posts.each do |post|
              post.row_column_data.each do |pixel|
                graphic.data[pixel.column + pixel.row * graphic.width] = pixel.pixel
              end
            end
          end
          return graphic
        else
          return nil
        end
      rescue e : IO::EOFError
        return nil
      rescue e : ArgumentError
        return nil
      rescue e : OverflowError
        return nil
      end
    end

    # :nodoc:
    # Parses pixel stuff for parsing a graphic.
    # Used because of a bug in the Crystal compiler
    def self.pixel_parse(pixel_column, column, post, io)
      post.length.times do |j|
        pixel = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        post.data << pixel
        row_column_pixel = GraphicParse::RowColumnPixel.new
        row_column_pixel.pixel = pixel
        row_column_pixel.row = j.to_u32 + post.topdelta.to_u32
        row_column_pixel.column = pixel_column.to_u32
        post.row_column_data << row_column_pixel
      end
      column.posts << post
    end

    # Checks to see if *name* is "S_START".
    #
    # Returns true if the name is a sprite marker start:
    # ```
    # sprite_mark_name = "S_START"
    # if WAD::Graphic.is_sprite_mark_start?(sprite_mark_name)
    #   puts "Is a Sprite Marker Start"
    # else
    #   puts "Is not a Sprite Marker Start"
    # end
    # ```
    def self.is_sprite_mark_start?(name : String)
      name =~ /^S_START/
    end

    # Checks to see if *name* is "S_END".
    #
    # Returns true if the name is a sprite marker end:
    # ```
    # sprite_mark_name = "S_END"
    # if WAD::Graphic.is_sprite_mark_end?(sprite_mark_name)
    #   puts "Is a Sprite Marker End"
    # else
    #   puts "Is not a Sprite Marker End"
    # end
    # ```
    def self.is_sprite_mark_end?(name : String)
      name =~ /^S_END/
    end
  end

  # A WAD flat
  class Flat
    property colors : Array(UInt8) = [] of UInt8
    property lump_bytes : Int32 = 4096
    property width : Int32 = 64
    property height : Int32 = 64

    # Sets a pixel in the flat to be *value*.
    # Raises an error if value is not within the bounds
    # of a `UInt8`
    #
    # NOTE: *value* does not refer to an rgb color,
    # but instead to an index in the colors of a `WAD::Playpal::Palette`
    #
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    #
    # my_flat = my_wad.flats["MyFlat"]
    #
    # my_flat[2, 3] # => Returns the value of the pixel at x=2 y=3
    #
    # my_flat.set_pixel(2, 3, 120) # => Sets the value of the pixel at x=2 y=3 to be 120
    #
    # my_flat[2, 3] # => 120
    #
    # my_flat.set_pixel(2, 3, -1) # => Raises an exception
    #
    # my_flat.set_pixel(2, 3, 256) # => Raises an exception
    # ```
    def set_pixel(x : Int, y : Int, value : Int)
      raise "Out of bounds" if x > width || y > height
      if self[x, y]
        begin
          colors[x + y * width] = value.to_u8
        rescue e : OverflowError
          raise "'#{value}' IS NOT WITHIN THE BOUNDS OF A UInt8"
        end
      end
    end

    def [](x : Int, y : Int)
      colors[x + y * width]
    end

    # Parses a flat file given the filename
    #
    # Opens a flat file and parses it:
    # ```
    # my_flat = WAD::Flat.parse("Path/To/Flat")
    # ```
    def self.parse(filename : String | Path) : Flat
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Flat invalid"
    end

    # Parses a flat file given the io
    #
    # Opens a flat io and parses it:
    # ```
    # File.open("Path/To/Flat") do |file|
    #   my_flat = WAD::Flat.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Flat
      flat = Flat.new

      flat.lump_bytes.times do
        flat.colors << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      end

      flat
    end

    # Checks to see if *name* is "F_START".
    #
    # Returns true if the name is a flat marker start:
    # ```
    # flat_mark_name = "F_START"
    # if WAD::Flat.is_flat_mark_start?(flat_mark_name)
    #   puts "Is a Flat Marker Start"
    # else
    #   puts "Is not a Flat Marker Start"
    # end
    # ```
    def self.is_flat_mark_start?(name : String)
      name =~ /^F_START/
    end

    # Checks to see if *name* is "F_END".
    #
    # Returns true if the name is a flat marker end:
    # ```
    # flat_mark_name = "F_END"
    # if WAD::Flat.is_flat_mark_end?(flat_mark_name)
    #   puts "Is a Flat Marker End"
    # else
    #   puts "Is not a Flat Marker End"
    # end
    # ```
    def self.is_flat_mark_end?(name : String)
      name =~ /^F_END/
    end
  end
end
