class WAD
  # A pc speaker sound effect.
  class PcSound
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
  end
end
