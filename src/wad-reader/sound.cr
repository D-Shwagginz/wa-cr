# Intends to overload the WAD class.
class WAD
  class PcSound
    # Parses PcSound lump
    def self.parse
    end

    # Checks to see if *name* is a pc sound with name format 'DPx..x'.
    def self.is_pcsound?(name)
      !!(name =~ /^DP/)
    end

    property format_num = 0_u16
    property samples_num = 0_u16
    property samples = [] of UInt8
  end

  class Sound
    def self.is_sound?(name)
      !!(name =~ /^DS/)
    end
  end
end
