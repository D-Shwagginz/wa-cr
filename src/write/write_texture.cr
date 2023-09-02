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
        name_slice = Bytes.new(8)
        name_slice.copy_from(WAD.slice_cut(WAD.string_cut(texture.name).to_slice))
        io.write(name_slice)
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
        name_slice = Bytes.new(8)
        name_slice.copy_from(WAD.slice_cut(WAD.string_cut(patch).to_slice))
        io.write(name_slice)
        lump_size += 8_u32
      end
      lump_size
    end
  end

  # A WAD graphic
  class Graphic
    def write(io) : UInt32
      file_start_position = io.pos
      dummy_value = 0_u8
      pixel_count = 0_u8
      lump_size = 0_u32
      column_offsets = [] of UInt32
      offset = 0_u32

      io.write_bytes(width.to_u16, IO::ByteFormat::LittleEndian)
      io.write_bytes(height.to_u16, IO::ByteFormat::LittleEndian)
      io.write_bytes(leftoffset.to_i16, IO::ByteFormat::LittleEndian)
      io.write_bytes(topoffset.to_i16, IO::ByteFormat::LittleEndian)

      buffer = IO::Memory.new

      width.times do |x|
        column_offsets << buffer.pos.to_u32
        y = 0_u8
        operator = true
        empty_post = false

        until y == height
          pixel = self.[x.to_i, y.to_i]

          if pixel.nil? && !operator
            operator = true
            if y != height - 1
              buffer.write_bytes(dummy_value.to_u8, IO::ByteFormat::LittleEndian)
              empty_post = true
            end
          elsif !pixel.nil? && operator
            empty_post = false
            row_start = y
            pixel_count = 1_u8
            dummy_value = 0_u8

            buffer.write_bytes(row_start.to_u8, IO::ByteFormat::LittleEndian)
            buffer.write_bytes(pixel_count.to_u8, IO::ByteFormat::LittleEndian)
            buffer.write_bytes(dummy_value.to_u8, IO::ByteFormat::LittleEndian)

            offset = buffer.pos.to_u32
            operator = false

            buffer.write_bytes(pixel.to_u8, IO::ByteFormat::LittleEndian)
          elsif !pixel.nil? && !operator
            empty_post = false
            pixel_count += 1_u8

            if offset > 0 && pixel_count > 0
              previous_offset = buffer.pos
              buffer.pos=(offset - 2)
              buffer.write_bytes(pixel_count.to_u8, IO::ByteFormat::LittleEndian)
              buffer.pos = previous_offset
            end

            buffer.write_bytes(pixel.to_u8, IO::ByteFormat::LittleEndian)
          end

          y += 1_u8
        end

        if operator || y == height
          if buffer.pos != 0
            if empty_post
              buffer.pos=(buffer.pos - 1)
            end

            buffer.pos=(buffer.pos - 1)

            if buffer.read_bytes(UInt8, IO::ByteFormat::LittleEndian) != 255
              pixel = 0

              buffer.write_bytes(pixel.to_u8, IO::ByteFormat::LittleEndian)
            end

            row_start = 255

            buffer.write_bytes(row_start.to_u8, IO::ByteFormat::LittleEndian)
          else
            row_start = 255

            buffer.write_bytes(row_start.to_u8, IO::ByteFormat::LittleEndian)
          end
        end
      end

      buffer.pos = 0

      offset = io.pos - file_start_position

      io.pos = file_start_position + 8

      column_offsets.size.times do |time|
        column_offset = column_offsets[time] + offset + (column_offsets.size*4)

        io.write_bytes(column_offset.to_u32, IO::ByteFormat::LittleEndian)
      end

      IO.copy(buffer, io)

      lump_size = io.pos.to_u32 - file_start_position.to_u32
      lump_size
    end
  end

  # A WAD flat
  class Flat
    def write(io) : UInt32
      lump_size = 0_u32

      width.times do |y|
        height.times do |x|
          io.write_bytes(self.[x, y].to_u8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end
      end

      lump_size
    end
  end
end
