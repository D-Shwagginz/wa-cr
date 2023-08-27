# Intends to overload the WAD class.
class WAD
  class PcSound
    SAMPLE_RATE = 140
    property name = ""
    property format_num = 0_u16
    property samples_num = 0_u16
    property samples = [] of UInt8

    # Parses a pc sound lump
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

  class Sound
    PAD_BYTES = 18
    property name = ""
    property format_num = 0_u16
    property sample_rate = 0_u16
    property samples_num = 0_u16
    property samples = [] of UInt8

    # Parses a sound lump
    def self.parse(io, name = "")
      sound = Sound.new
      sound.name = name
      sound.format_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.sample_rate = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      sound.samples_num = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      # Bleeds the pad bytes out
      PAD_BYTES.times do
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
  end
end
