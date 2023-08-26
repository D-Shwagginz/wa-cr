# Intends to overload the WAD class.
class WAD
  class PcSound
    # Checks to see if *name* is a pc sound with name format 'DPx..x'.
    def self.is_pcsound?(name)
      if name =~ /DP/
        puts name
      end
    end
  end

  class Sound
  end
end
