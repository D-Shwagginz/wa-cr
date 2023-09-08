class WAD
  class Sound
    # Writes to wav file given an output *file*.
    #
    # Writes a 'wav' file from the *my_wad* sound "DSPISTOL":
    # ```
    # my_wad.sounds["DSPISTOL"].to_wav("Path/To/MyWav.wav")
    # ```
    def to_wav(filename : String | Path)
      File.open(filename, "w+") do |io|
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
      io.write_bytes(samples.size.to_u32, IO::ByteFormat::LittleEndian)

      # Packs samples
      samples.each do |sample|
        io.write_bytes(sample, IO::ByteFormat::LittleEndian)
      end
    end

    # Converts a .wav file to a `WAD::Sound` given a *filename*
    #
    # ```
    # my_wav_sound = WAD::Sound.from_wav("Path/To/Sound.wav")
    # ```
    def self.from_wav(filename : String | Path) : Sound
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

  class Graphic
  end

  class Flat
  end
end
