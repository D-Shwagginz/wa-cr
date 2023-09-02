# Intends to overload the WAD class.
class WAD
  # A pc speaker sound effect.
  class PcSound
    def write(io) : UInt32
      lump_size = 0_u32

      io.write_bytes(format_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(samples_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      samples.each do |sample|
        io.write_bytes(sample.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end
      lump_size
    end
  end

  # A normal sound effect.
  class Sound
    def write(io) : UInt32
      lump_size = 0_u32

      io.write_bytes(format_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(sample_rate.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(samples_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      (PAD_BYTES + 2).times do
        io.write_bytes(0.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      io.write_bytes(0.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      samples.each do |sample|
        io.write_bytes(sample.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      (PAD_BYTES + 2).times do
        io.write_bytes(0.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      lump_size
    end
  end
end
