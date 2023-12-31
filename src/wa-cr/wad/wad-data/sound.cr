class WAD
  # A pc speaker sound effect.
  class PcSound
    # Defines the #clone method
    def_clone

    SAMPLE_RATE = 140
    property format_num : UInt16 = 0_u16
    property samples_num : UInt16 = 0_u16
    property samples : Array(UInt8) = [] of UInt8

    # Parses a pc sound lump.
    #
    # Opens a pc sound file and parses it:
    # ```
    # my_pcsound = WAD::PcSound.parse("Path/To/PcSound")
    # ```
    def self.parse(filename : String | Path) : PcSound
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Pc Sound invalid"
    end

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
    # Defines the #clone method
    def_clone

    PAD_BYTES = 16
    property format_num : UInt16 = 0_u16
    # UInt16 | UInt32 because when reading from a .wav,
    # sample_rate is given in a UInt32
    property sample_rate : UInt16 | UInt32 = 0_u16
    # UInt16 | UInt32 because when reading from a .wav,
    # sample_num is given in a UInt32
    property samples_num : UInt16 | UInt32 = 0_u16
    property samples : Array(UInt8) = [] of UInt8

    # Parses a sound lump.
    #
    # Opens a sound file and parses it:
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

    # Writes to wav file given an output *file* and returns the written file's size.
    #
    # Writes a 'wav' file from the *my_wad* sound "DSPISTOL":
    # ```
    # my_wad.sounds["DSPISTOL"].to_wav("Path/To/MyWav.wav")
    # ```
    def to_wav(filename : String | Path) : UInt32
      filename = filename.to_s
      filename = filename + ".wav" if filename[filename.rindex!('.'), filename.size - 1] != ".wav"
      File.open(filename, "w+") do |io|
        to_wav(io)
      end
    end

    # Writes to wav file given an output *io* and returns the written file's size.
    #
    # Writes a 'wav' file from the *my_wad* sound "DSPISTOL":
    # ```
    # File.open("Path/To/MyWav.wav", "w+") do |io|
    #   my_wad.sounds["DSPISTOL"].to_wav(io)
    # end
    # ```
    def to_wav(io : IO) : UInt32
      file_size = 0_u32

      io << "RIFF"
      file_size += 4_u32
      # Size of the overall file - 8 bytes, in bytes (32-bit integer).
      io.write_bytes(4 + 24 + 8 + samples.size.to_u32, IO::ByteFormat::LittleEndian)
      file_size += 4_u32
      io << "WAVEfmt "
      file_size += 8_u32
      # Length of format data.
      io.write_bytes(16_u32, IO::ByteFormat::LittleEndian)
      file_size += 4_u32
      # Type of format (1 is PCM) - 2 byte integer.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      file_size += 2_u32
      # Number of Channels - 2 byte integer.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      file_size += 2_u32
      # Sample Rate - 32 byte integer.
      io.write_bytes(sample_rate.to_u32, IO::ByteFormat::LittleEndian)
      file_size += 4_u32
      # (Sample Rate * BitsPerSample * Channels) / 8.
      io.write_bytes(sample_rate.to_u32, IO::ByteFormat::LittleEndian)
      file_size += 4_u32
      # (BitsPerSample * Channels) / 8 : 1 - 8 bit mono | /16 bit mono4 - 16 bit stereo : 2 - 8 bit stereo.
      io.write_bytes(1_u16, IO::ByteFormat::LittleEndian)
      file_size += 2_u32
      # Bits per sample.
      io.write_bytes(8_u16, IO::ByteFormat::LittleEndian)
      file_size += 2_u32
      io << "data"
      file_size += 4_u32
      # Size of the data section.
      io.write_bytes(samples.size.to_u32, IO::ByteFormat::LittleEndian)
      file_size += 4_u32

      # Packs samples
      samples.each do |sample|
        io.write_bytes(sample, IO::ByteFormat::LittleEndian)
        file_size += 1_u32
      end

      return file_size
    end

    # Converts a .wav file to a `WAD::Sound` given a *filename*
    #
    # ```
    # my_wav_sound = WAD::Sound.from_wav("Path/To/Sound.wav")
    # ```
    def self.from_wav(filename : String | Path) : Sound
      filename = filename.to_s
      filename = filename + ".wav" if filename[filename.rindex!('.'), filename.size - 1] != ".wav"
      File.open(filename) do |io|
        return self.from_wav(io)
      end
    end

    # Converts a .wav file to a `WAD::Sound` given a *io*
    #
    # ```
    # File.open("Path/To/Sound.wav") do |io|
    #   my_wav_sound = WAD::Sound.from_wav(io)
    # end
    # ```
    def self.from_wav(io : IO) : Sound
      sound = Sound.new
      sound.format_num = 3_u16

      begin
        # Reads "RIFF"
        io.gets(4)
        # Size of the overall file
        io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        # Reads "WAVEfmt "
        io.gets(8)
        # Length of format data
        io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        # Type of format (1 is PCM) - 2 byte integer
        io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        # Number of Channels
        io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        # Sample Rate
        sound.sample_rate = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        # (Sample Rate * BitsPerSample * Channels) / 8.
        io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
        # (BitsPerSample * Channels) / 8 : 1 - 8 bit mono | /16 bit mono4 - 16 bit stereo : 2 - 8 bit stereo.
        io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        # Bits per sample
        if io.read_bytes(UInt16, IO::ByteFormat::LittleEndian) != 8_u16
          raise ".wav is not 8bit"
        end
        # Reads "data"
        io.gets(4)
        # Size of the data section
        sound.samples_num = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)

        # Reads samples
        sound.samples_num.times do
          sound.samples << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        end

        return sound
      rescue e : IO::EOFError
        raise "Not a valid .wav"
      end
    end
  end
end
