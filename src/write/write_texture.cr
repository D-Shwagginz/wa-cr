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
    def write(io) : UInt32
      lump_size = 0_u32

      io.write_bytes(numtextures.to_i32, IO::ByteFormat::LittleEndian)
      lump_size += 4_u32

      offsets.each do |offset|
        io.write_bytes(offset.to_i32, IO::ByteFormat::LittleEndian)
        lump_size += 4_u32
      end

      mtextures.each do |texture|
        string_slice = Bytes.new(8)
        string_slice.copy_from(texture.name.to_slice)
        io.write(string_slice)
        lump_size += 8_u32

        if texture.masked
          io.write_bytes(1.to_i32, IO::ByteFormat::LittleEndian)
          lump_size += 4_u32
        else
          io.write_bytes(0.to_i32, IO::ByteFormat::LittleEndian)
          lump_size += 4_u32
        end

        io.write_bytes(texture.width.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(texture.height.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(texture.columndirectory.to_i32, IO::ByteFormat::LittleEndian)
        lump_size += 4_u32
        io.write_bytes(texture.patchcount.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32

        texture.patches.each do |patch|
          io.write_bytes(patch.originx.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(patch.originy.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(patch.patch.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(patch.stepdir.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(patch.colormap.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end
      end
      lump_size
    end
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
    def write(io) : UInt32
      dummy_value = 0_u8
      pixel_count = 0_u8
      lump_size = 0_u32
      column_offsets = [] of UInt32
      x = 0
      offset = 0_u32

      io.write_bytes(width.to_u16, IO::ByteFormat::LittleEndian)
      io.write_bytes(height.to_u16, IO::ByteFormat::LittleEndian)
      io.write_bytes(leftoffset.to_i16, IO::ByteFormat::LittleEndian)
      io.write_bytes(topoffset.to_i16, IO::ByteFormat::LittleEndian)

      buffer = IO::Memory.new

      loop do
        break if x == width

        column_offsets << buffer.pos.to_u32
        y = 0_u8
        operator = true

        loop do
          break if y == height
          pixel = data[x.to_i + y.to_i * width]

          if pixel.nil? && !operator
            buffer.write_bytes(dummy_value.to_u8, IO::ByteFormat::LittleEndian)

            operator = true

          elsif !pixel.nil? && operator
            row_start = y
            pixel_count = 0_u8
            dummy_value = 0_u8
            
            buffer.write_bytes(row_start.to_u8, IO::ByteFormat::LittleEndian)
            buffer.write_bytes(pixel_count.to_u8, IO::ByteFormat::LittleEndian)
            buffer.write_bytes(dummy_value.to_u8, IO::ByteFormat::LittleEndian)

            offset = buffer.pos.to_u32
            operator = false

          elsif !pixel.nil? && !operator
            pixel_count += 1_u8

            if offset > 0 && pixel_count > 0
              previous_offset = buffer.pos
              buffer.pos=(buffer.pos-(offset-2))
              buffer.write_bytes(pixel_count.to_u8, IO::ByteFormat::LittleEndian)
              buffer.pos=previous_offset
            end

            buffer.write_bytes(pixel.to_u8, IO::ByteFormat::LittleEndian)
          end

          y += 1_u8
        end

        if operator || y == height
          pixel = 0

          buffer.write_bytes(pixel.to_u8, IO::ByteFormat::LittleEndian)

          row_start = 255

          buffer.write_bytes(row_start.to_u8, IO::ByteFormat::LittleEndian)

          buffer.write_bytes(0.to_u8, IO::ByteFormat::LittleEndian)
        end

        x += 1
      end

      buffer.pos=0

      offset = io.pos

      io.pos=8

      column_offsets.size.times do |time|
        column_offset = column_offsets[time] + offset

        io.write_bytes(column_offset.to_u32, IO::ByteFormat::LittleEndian)
      end

      IO.copy(buffer, io)

      io.pos=0
      lump_size = io.each_byte.size.to_u32

      puts lump_size
      lump_size
    end
  end

  # A WAD flat
  class Flat
  end
end
