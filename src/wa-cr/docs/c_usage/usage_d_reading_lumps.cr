module A_Overview
  module C_Usage
    # A [Wad](https://doomwiki.org/wiki/WAD) is a file that contains [Lumps](https://doomwiki.org/wiki/Lump).<br>
    # A [Lumps](https://doomwiki.org/wiki/Lump) is a chunk of data.
    # It can be a [Graphic](https://doomwiki.org/wiki/Graphics),
    # a [Sound](https://doomwiki.org/wiki/Sound),
    # [Map data](https://doomwiki.org/wiki/WAD#:~:text=location%20is%20crucial.-,Map%20data%20lumps,-%5Bedit%5D),
    # etc.<br>
    #
    # While you can read [Wads](https://doomwiki.org/wiki/WAD)
    # in, you can also directly read [Lumps](https://doomwiki.org/wiki/Lump) in:
    #
    # NOTE: "LMP or lmp is the file extension for lump files" - [Wiki](https://doomwiki.org/wiki/LMP)
    #
    # ```
    # my_graphic_lump = WAD::Graphic.parse("Path/To/MyGraphic.lmp") # => Returns the parsed graphic
    # my_sound_lump = WAD::Sound.parse("Path/To/MySound.lmp")       # => Returns the parsed sound
    # ```
    #
    # You can also read lumps directly into a `WAD` with `WAD#add(name, type, file)`:
    #
    # NOTE: Types you can add are ("PcSound", "Sound", "Music", "TextureX", "Graphic", "Flat", "Demo")
    #
    # ```
    # my_new_wad = WAD.new(WAD::Type::Internal) # => Creates a new WAD with type internal
    #
    # # Adds a graphic to *my_new_wad* with the name "MyGraphic"
    # my_new_wad.add("MyGraphic", "Graphic", "Path/To/MyGraphic.lmp"))
    #
    # # Adds a sound to *my_new_wad* with the name "MySound"
    # my_new_wad.add("MySound", "Sound", "Path/To/MySound.lmp")
    # ```
    #
    module D_ReadingLumps
    end
  end
end
