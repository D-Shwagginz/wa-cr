# Intends to overload the WAD class.
class WAD
  # A pc speaker sound effect.
  class PcSound
    SAMPLE_RATE = 140
    property name = ""
    property format_num = 0_u16
    property samples_num = 0_u16
    property samples = [] of UInt8

    # Parses a pc sound lump.
    def self.parse(io, name = "")
      pcsound = PcSound.new
      pcsound.name = name
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
    def self.is_pcsound?(name)
      !!(name =~ /^DP/)
    end
  end

  # A normal sound effect.
  class Sound
    PAD_BYTES = 16
    property name = ""
    property format_num = 0_u16
    property sample_rate = 0_u16
    property samples_num = 0_u16
    property samples = [] of UInt8

    # Parses a sound lump.
    def self.parse(io, name = "")
      sound = Sound.new
      sound.name = name
      sound.format_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.sample_rate = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.samples_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      # Bleeds the pad bytes out.
      (PAD_BYTES+2).times do
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
    def self.is_sound?(name)
      !!(name =~ /^DS/)
    end

    # Exports to wav given an *io*.
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
