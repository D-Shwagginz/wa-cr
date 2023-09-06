module A_Overview
  module C_Usage
    # A `WAD::Directory` is a struct that holds information about a [Lump](https://doomwiki.org/wiki/Lump)<br>
    # It acts as a librarian who tells you the location, name, and size of a book in the library<br>
    # To dive deeper into directories and a wad's layout,
    # it is recommended you read the doom wiki's entry on [Wads](https://doomwiki.org/wiki/WAD)
    #
    # NOTE: Directories relating to a map, e.g. things, linedefs, etc, are
    # stored in the `WAD::Map` class itself
    #
    # ```
    # my_map = my_wad.maps["MyMap"]                     # => Returns the map "MyMap" out of *my_wad*
    # my_things_directory = my_map.things_directory     # => Returns the directory of the things lump for the map "MyMap"
    # my_linedefs_directory = my_map.linedefs_directory # => Returns the linedefs directory of the linedefs lump for the map "MyMap"
    # ```
    #
    # ### Making New Directories
    #
    # When manually adding anything to a `WAD`, e.g. a graphic, sound, map, etc,
    # you need to call the `WAD#new_dir(name)` method to add a new directory
    # to the `WAD`.
    #
    # NOTE: When adding something to a map, e.g. a thing, linedef, sidedef, etc,
    # you don't have to worry about making a new directory
    #
    # The *name* input of `WAD#new_dir(name)` needs to be the EXACT SAME as
    # the name of the variable/lump it is refering to:
    #
    # ```
    # my_new_wad = WAD.new(WAD::Type::Internal)
    #
    # my_new_wad.sounds["MyNewSound"] = WAD::Sound.new
    #
    # # This WON'T refer to the new sound
    # my_new_wad.new_dir("MySound")
    #
    # # This WILL refer to the new sound
    # my_new_wad.new_dir("MyNewSound")
    # ```
    #
    # If you don't use `WAD#new_dir(name)`, the lump won't be written out when
    # writing the `WAD`:
    #
    # ```
    # require "wa-cr/write"
    #
    # my_new_wad = WAD.new(WAD::Type::Internal)
    #
    # my_new_wad.graphics["MyNewGraphic"] = WAD::Graphic.new
    #
    # # The WAD it writes will be empty
    # my_new_wad.write("Path/To/MyWad.WAD")
    #
    # # Creates a new directory with the same name as the graphic
    # my_new_wad.new_dir("MyNewGraphic")
    #
    # # The WAD it writes will contain one graphic
    # my_new_wad.write("Path/To/MyWad.WAD")
    # ```
    #
    # NOTE: When using `WAD#add(name, type, file)`, the directory is added automatically
    module C_OnDirectories
    end
  end
end
