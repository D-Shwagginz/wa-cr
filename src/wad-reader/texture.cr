# Intends to overload the WAD class.
class WAD
  # The set of color palettes
  class Playpal
    property pallets = [] of Pallet

    # A color pallet
    struct Pallet
      property colors = [] of Color
    end

    # A color
    struct Color
      property r = 0_u8
      property g = 0_u8
      property b = 0_u8
    end

    def self.parse(io)
      playpal = Playpal.new
      colors_per_palette = 256
      amount_of_palettes = 14

      amount_of_palettes.times do
        pallet = Pallet.new
        (colors_per_palette).to_i.times do
          color = Color.new
          color.r = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.g = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          color.b = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          pallet.colors << color
        end
        playpal.pallets << pallet
      end
      playpal
    end

    # Checks to see if *name* is "PLAYPAL"
    def self.is_playpal?(name)
      !!(name =~ /^PLAYPAL/)
    end
  end
end
