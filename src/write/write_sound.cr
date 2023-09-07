module WritingAdditions
  # A pc speaker sound effect.
  module PcSound
    # Writes a pc sound given an output io and returns the size of the written lump
    #
    # Writes a pc sound in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # my_wad.pcsounds.["MyPcSound"].write("Path/To/pcsound.lmp")
    # ```
    def write(file : String | Path) : UInt32
      File.open(file, "w+") do |file|
        return write(file)
      end
    end

    # Writes a pc sound given an output io and returns the size of the written lump
    #
    # Writes a pc sound in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # File.open("Path/To/pcsound.lmp", "w+") do |file|
    #   my_wad.pcsounds.["MyPcSound"].write(file)
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
    # my_wad = WAD.read("Path/To/Wad")
    # my_wad.sounds["MySound"].write("Path/To/sound.lmp")
    # ```
    def write(file : String | Path) : UInt32
      File.open(file, "w+") do |file|
        return write(file)
      end
    end

    # Writes a sound given an output io and returns the size of the written lump
    #
    # Writes a sound in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # File.open("Path/To/sound.lmp", "w+") do |file|
    #   my_wad.sounds["MySound"].write(file)
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
