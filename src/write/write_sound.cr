# Intends to overload the WAD class.
class WAD
  # A pc speaker sound effect.
  class PcSound
    # Writes a pc sound given an output io and returns the size of the written lump
    #
    # Example: Writes a pc sound in *mywad* to a file
    # ```
    # mywad = WAD.read("./rsrc/DOOM.WAD")
    # File.open("./rsrc/pcsound.lmp", "w+") do |file|
    #   mywad.pcsound.values[0].write(file)
    # end
    # ```
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
    # Writes a sound given an output io and returns the size of the written lump
    #
    # Example: Writes a sound in *mywad* to a file
    # ```
    # mywad = WAD.read("./rsrc/DOOM.WAD")
    # File.open("./rsrc/sound.lmp", "w+") do |file|
    #   mywad.sound.values[0].write(file)
    # end
    # ```
    def write(io) : UInt32
      lump_size = 0_u32

      io.write_bytes(format_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(sample_rate.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32
      io.write_bytes(samples_num.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      # pad bytes
      io.write_bytes(0.to_u16, IO::ByteFormat::LittleEndian)
      lump_size += 2_u32

      PAD_BYTES.times do
        io.write_bytes(samples[0].to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      samples.each do |sample|
        io.write_bytes(sample.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      PAD_BYTES.times do
        io.write_bytes(samples[-1].to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      lump_size
    end
  end
end
