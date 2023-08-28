# Intends to overload the WAD class.
class WAD
  # The set of color palettes
  class Playpal
    property pallets = [] of Pallet

    # A color pallet
    struct Pallet
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
        pallet = Pallet.new
        (colors_per_palette).to_i.times do
          color = Color.new
          color.r = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.g = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.b = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          pallet.colors << color
        end
        playpal.pallets << pallet
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
    struct Table
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

  # Defines how wall patches from the WAD file should combine to form wall textures.
  class TextureX
    property numtextures = 0_i32
    property offsets = [] of Int32
    property mtextures = [] of TextureMap

    # "The binary contents of the maptexture_t structure starts with a header of 22 bytes, followed by all the map patches."
    struct TextureMap
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
end
