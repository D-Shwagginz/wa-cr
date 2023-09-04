module WritingAdditions
  # A pc speaker sound effect.
  module PcSound
    # Writes a pc sound given an output io and returns the size of the written lump
    #
    # Writes a pc sound in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("./rsrc/DOOM.WAD")
    # File.open("./rsrc/pcsound.lmp", "w+") do |file|
    #   my_wad.pcsound.values[0].write(file)
    # end
    # ```
    def write(io : IO) : UInt32
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
  module Sound
    # Writes a sound given an output io and returns the size of the written lump
    #
    # Writes a sound in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("./rsrc/DOOM.WAD")
    # File.open("./rsrc/sound.lmp", "w+") do |file|
    #   my_wad.sound.values[0].write(file)
    # end
    # ```
    def write(io : IO) : UInt32
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

      ::WAD::Sound::PAD_BYTES.times do
        io.write_bytes(samples[0].to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      samples.each do |sample|
        io.write_bytes(sample.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      ::WAD::Sound::PAD_BYTES.times do
        io.write_bytes(samples[-1].to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      lump_size
    end
  end
end
