# Intends to overload the WAD class.
class WAD
  # The set of color palettes
  class Playpal
    property palettes = [] of Palette

    # A color palette
    class Palette
      property colors = [] of Color
    end

    # A color
    struct Color
      property r = 0_u8
      property g = 0_u8
      property b = 0_u8
    end

    def self.parse(io)
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
    def self.is_playpal?(name)
      !!(name =~ /^PLAYPAL/)
    end
  end

  # The color map
  class Colormap
    property tables = [] of Table

    # A colormap containing it's table's data
    class Table
      property table = [] of UInt8
    end

    def self.parse(io)
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
    def self.is_colormap?(name)
      !!(name =~ /^COLORMAP/)
    end
  end

  # "The colorful screen shown when Doom exits."
  class EnDoom
    property characters = [] of EnDoomChars

    struct EnDoomChars
      property ascii_value = 0_u8
      property color = 0_u8
    end

    def self.parse(io)
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
    def self.is_texturex?(name)
      !!(name =~ /^ENDOOM/)
    end
  end

  # Defines how wall patches from the WAD file should combine to form wall textures.
  class TextureX
    property numtextures = 0_i32
    property offsets = [] of Int32
    property mtextures = [] of TextureMap

    # "The binary contents of the maptexture_t structure starts with a header of 22 bytes, followed by all the map patches."
    class TextureMap
      property name = ""
      property masked : Bool = false
      property width = 0_i16
      property height = 0_i16
      property columndirectory = 0_i32
      property patchcount = 0_i16
      property patches = [] of Patch
    end

    # "The binary contents of the mappatch_t structure contains 10 bytes defining how the patch should be drawn inside the texture."
    struct Patch
      property originx = 0_i16
      property originy = 0_i16
      property patch = 0_i16
      property stepdir = 0_i16
      property colormap = 0_i16
    end

    def self.parse(io)
      texturex = TextureX.new
      texturex.numtextures = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)

      # Reads the offset to the map textures
      texturex.numtextures.times do
        texturex.offsets << io.read_bytes(Int32, IO::ByteFormat::LittleEndian)
      end

      texturex.offsets.each do
        texturemap = TextureMap.new
        texturemap.name = io.gets(8).to_s.gsub("\u0000", "")
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
    def self.is_texturex?(name)
      !!(name =~ /^TEXTURE\d/)
    end
  end

  # Includes all the names for wall patches.
  class Pnames
    property num_patches = 0_i32
    property patches = [] of String

    def self.parse(io)
      pnames = Pnames.new

      pnames.num_patches = io.read_bytes(Int32, IO::ByteFormat::LittleEndian)

      pnames.num_patches.times do
        pnames.patches << io.gets(8).to_s.gsub("\u0000", "")
      end
      pnames
    end

    # Checks to see if *name* is "PNAMES"
    def self.is_pnames?(name)
      !!(name =~ /^PNAMES/)
    end
  end

  # A WAD graphic
  class Graphic
    property name : String = ""
    property width : UInt16 = 0_u16
    property height : UInt16 = 0_u16
    property leftoffset : Int16 = 0_i16
    property rightoffset : Int16 = 0_i16
    property columnoffsets : Array(UInt32) = [] of UInt32
    property columns : Array(Column) = [] of Column
    property predicted_size : UInt32 = 0_u32

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

    def self.parse(file, directory)
      begin
        graphic = Graphic.new
        graphic.name = directory.name

        file.read_at(directory.file_pos, directory.size) do |io|
          graphic.width = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          graphic.height = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
          graphic.leftoffset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          graphic.rightoffset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          graphic.width.times do
            graphic.columnoffsets << io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
          end
          graphic.predicted_size += (graphic.width*4) + 8

          graphic.width.times do |i|
            file.read_at(directory.file_pos + graphic.columnoffsets[i], directory.size) do |io|
              rowstart = 0
              column = Column.new

              loop do
                rowstart = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                post = Post.new
                post.topdelta = rowstart
                break if rowstart == 255

                post.length = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                graphic.predicted_size += post.length.to_u32 + 4.to_u32
                dummy = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                # break if dummy == 255
                # post.length.times do |j|
                #   pixel = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
                #   post.data << pixel
                #   row_column_pixel = RowColumnPixel.new
                #   row_column_pixel.pixel = pixel
                #   row_column_pixel.row = j + rowstart
                #   row_column_pixel.column = i
                #   column.posts << post
                # end

                pixel_parse(i, column, post, io)
                dummy = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
              end
              graphic.columns << column
            end
          end
        end
        # puts directory.name
        # puts graphic.predicted_size
        # puts directory.size
        return graphic
      rescue e : IO::EOFError
        return nil
      rescue e : ArgumentError
        return nil
      end
    end

    def self.pixel_parse(pixel_column, column, post, io)
      post.length.times do |j|
        pixel = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        post.data << pixel
        row_column_pixel = RowColumnPixel.new
        row_column_pixel.pixel = pixel
        row_column_pixel.row = j.to_u32 + post.topdelta.to_u32
        row_column_pixel.column = pixel_column
      end
      column.posts << post
    end

    # Checks to see if *name* is "S_START".
    def self.is_sprite_mark_start?(name)
      name =~ /^S_START/
    end

    # Checks to see if *name* is "S_END".
    def self.is_sprite_mark_end?(name)
      name =~ /^S_END/
    end
  end

  class Flat
    property colors = [] of UInt8

    def self.parse(io)
      flat = Flat.new
      lump_bytes = 4096

      lump_bytes.times do
        flat.color << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      end
      flat
    end

    # Checks to see if *name* is "F_START".
    def self.is_flat_mark_start?(name)
      name =~ /^F_START/
    end

    # Checks to see if *name* is "F_END".
    def self.is_flat_mark_end?(name)
      name =~ /^F_END/
    end
  end
end
