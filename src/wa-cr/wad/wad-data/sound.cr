class WAD
  # A pc speaker sound effect.
  class PcSound
    SAMPLE_RATE = 140
    property format_num : UInt16 = 0_u16
    property samples_num : UInt16 = 0_u16
    property samples : Array(UInt8) = [] of UInt8

    # Parses a pc sound lump.
    #
    # Opens a pc sound io and parses it:
    # ```
    # File.open("Path/To/PcSound") do |file|
    #   my_pcsound = WAD::PcSound.parse(file)
    # end
    # ```
    def self.parse(io : IO) : PcSound
      pcsound = PcSound.new
      pcsound.format_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      pcsound.samples_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sample_index = 0

      while sample_index < pcsound.samples_num
        pcsound.samples << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        sample_index += 1
      end
      pcsound
    end

    # Checks to see if *name* is a pc sound with name format 'DPx..x'.
    #
    # Returns true if the name is a pc sound:
    # ```
    # pcsound_name = "DPNOWAY"
    # if WAD::PcSound.is_pcsound?(pcsound_name)
    #   puts "Is a Pc Sound"
    # else
    #   puts "Is not a Pc Sound"
    # end
    # ```
    def self.is_pcsound?(name : String)
      !!(name =~ /^DP/)
    end
  end

  # A normal sound effect.
  class Sound
    PAD_BYTES = 16
    property format_num : UInt16 = 0_u16
    property sample_rate : UInt16 = 0_u16
    property samples_num : UInt16 = 0_u16
    property samples : Array(UInt8) = [] of UInt8

    # Parses a sound lump.
    #
    # Opens a sound io and parses it:
    # ```
    # my_sound = WAD::Sound.parse("Path/To/Sound")
    # ```
    def self.parse(filename : String | Path) : Sound
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Sound invalid"
    end

    # Parses a sound lump.
    #
    # Opens a sound io and parses it:
    # ```
    # File.open("Path/To/Sound") do |file|
    #   my_sound = WAD::Sound.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Sound
      sound = Sound.new
      sound.format_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.sample_rate = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.samples_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      # Bleeds the pad bytes out.
      (PAD_BYTES + 2).times do
        io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      end

      sample_index = 0
      while sample_index < sound.samples_num - (PAD_BYTES*2)
        sound.samples << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        sample_index += 1
      end

      sound
    end

    # Checks to see if *name* is a sound with name format 'DSx..x'.
    #
    # Returns true if the name is a sound:
    # ```
    # sound_name = "DSNOWAY"
    # if WAD::Sound.is_sound?(sound_name)
    #   puts "Is a Sound"
    # else
    #   puts "Is not a Sound"
    # end
    # ```
    def self.is_sound?(name : String)
      !!(name =~ /^DS/)
    end

    def to_wav(file : File | Path)
      File.open(file, "w+") do |io|
        to_wav(io)
      end
    end

    # Writes to wav file given an output *io*.
    #
    # Writes a 'wav' file from the *my_wad* sound "DSPISTOL":
    # ```
    # File.open("Path/To/MyWav.wav", "w+") do |io|
    #   my_wad.sounds["DSPISTOL"].to_wav(io)
    # end
    # ```
    def to_wav(io : IO)
      io << "RIFF"
      # Size of the overall file - 8 bytes, in bytes (32-bit integer).
      io.write_bytes(4 + 24 + 8 + samples.size.to_u32, IO::ByteFormat::LittleEndian)
      io << "WAVEfmt "
      # Length of format data.
      io.write_bytes(16_u32, IO::ByteFormat::LittleEndian)
      # Type of format (1 is PCM) - 2 byte integer.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      # Number of Channels - 2 byte integer.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      # Sample Rate - 32 byte integer.
      io.write_bytes(sample_rate.to_u32, IO::ByteFormat::LittleEndian)
      # (Sample Rate * BitsPerSample * Channels) / 8.
      io.write_bytes(sample_rate.to_u32, IO::ByteFormat::LittleEndian)
      # (BitsPerSample * Channels) / 8 : 1 - 8 bit mono | /16 bit mono4 - 16 bit stereo : 2 - 8 bit stereo.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      # Bits per sample.
      io.write_bytes(8_u16, IO::ByteFormat::LittleEndian)
      io << "data"
      # Size of the data section.
      io.write_bytes(samples.size, IO::ByteFormat::LittleEndian)

      # Packs samples
      samples.each do |sample|
        io.write_bytes(sample, IO::ByteFormat::LittleEndian)
      end
    end
  end
end
