# Intends to overload the WAD class.
class WAD
  # The set of color palettes
  class Playpal
    def write(io) : UInt32
      lump_size = 0_u32

      palettes.each do |palette|
        palette.colors.each do |color|
          io.write_bytes(color.r.to_u8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
          io.write_bytes(color.g.to_u8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
          io.write_bytes(color.b.to_u8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end
      end
      lump_size
    end
  end

  # The color map
  class Colormap
    def write(io) : UInt32
      lump_size = 0_u32
      tables.each do |table|
        table.table.each do |value|
          io.write_bytes(value.to_u8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end
      end
      lump_size
    end
  end

  # "The colorful screen shown when Doom exits."
  class EnDoom
    def write(io) : UInt32
      lump_size = 0_u32

      characters.each do |character|
        io.write_bytes(character.ascii_value.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
        io.write_bytes(character.color.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end
      lump_size
    end
  end

  # Defines how wall patches from the WAD file should combine to form wall textures.
  class TextureX
  end

  # Includes all the names for wall patches.
  class Pnames
    def write(io) : UInt32
      lump_size = 0_u32

      io.write_bytes(num_patches.to_i32, IO::ByteFormat::LittleEndian)
      lump_size += 4_u32

      patches.each do |patch|
        patch_slice = Bytes.new(8)
        patch_slice.copy_from(patch.to_slice)
        io.write(patch_slice)
        lump_size += 8_u32
      end
      lump_size
    end
  end

  # A WAD graphic
  class Graphic
  end

  # A WAD flat
  class Flat
  end
end
