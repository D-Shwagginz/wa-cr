# Intends to overload the WAD class.
class WAD
  # A music track.
  class Music
    def write(io) : UInt32
      lump_size = 0_u32

      io.print(identifier)
      lump_size += 4_u32

      io.write_bytes(score_len.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(score_start.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(channels.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(sec_channels.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(instr_cnt.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      io.write_bytes(0.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      instruments.each do |instrument|
        io.write_bytes(instrument.to_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
      end

      song.each do |value|
        io.write_bytes(value.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end
      lump_size
    end
  end

  # "Instrument data for the DMX sound library to use for OPL synthesis".
  class Genmidi
    def write(io) : UInt32
      lump_size = 0_u32

      io.print(header)
      lump_size += header.bytesize.to_u32

      instr_datas.each do |instr_data|
        io.write_bytes(instr_data.header[0].to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(instr_data.header[1].to_i8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
        io.write_bytes(instr_data.header[2].to_i8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32

        # First 14 bytes are all 1 byte in size
        14.times do |time|
          io.write_bytes(instr_data.voice1_data[time].to_i8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end
        io.write_bytes(instr_data.voice1_data[14].to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32

        # First 14 bytes are all 1 byte in size
        14.times do |time|
          io.write_bytes(instr_data.voice2_data[time].to_i8, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end
        io.write_bytes(instr_data.voice2_data[14].to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
      end

      instr_names.each do |name|
        name_slice = Bytes.new(32)
        name_slice.copy_from(name.to_slice)
        io.write(name_slice)
        lump_size += 32_u32
      end
      lump_size
    end
  end

  # "Instrument data for the DMX sound library to use for Gravis Ultrasound soundcards".
  class Dmxgus
    def write(io) : UInt32
      lump_size = 0_u32

      instr_datas.each do |instr_data|
        io.print(instr_data.patch.to_s)
        lump_size += instr_data.patch.to_s.bytesize.to_u32
        io.print(",")
        lump_size += ",".bytesize.to_u32

        io.print(instr_data.a_k.to_s)
        lump_size += instr_data.a_k.to_s.bytesize.to_u32
        io.print(",")
        lump_size += ",".bytesize.to_u32

        io.print(instr_data.b_k.to_s)
        lump_size += instr_data.b_k.to_s.bytesize.to_u32
        io.print(",")
        lump_size += ",".bytesize.to_u32

        io.print(instr_data.c_k.to_s)
        lump_size += instr_data.c_k.to_s.bytesize.to_u32
        io.print(",")
        lump_size += ",".bytesize.to_u32

        io.print(instr_data.d_k.to_s)
        lump_size += instr_data.d_k.to_s.bytesize.to_u32
        io.print(",")
        lump_size += ",".bytesize.to_u32

        io.print(instr_data.filename)
        lump_size += instr_data.filename.bytesize.to_u32
        io.print("\n")
        lump_size += "\n".bytesize.to_u32
      end
      lump_size
    end
  end
end
