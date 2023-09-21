module Documentation
  module C_Usage
    # The wa-cr `WritingAdditions` allow easy writing of [WAD](https://doomwiki.org/wiki/WAD)
    # and [Lump](https://doomwiki.org/wiki/Lump) files.<br>
    # To use the `WritingAdditions`, just require `wa-cr/write`:
    #
    # ```
    # require "wa-cr/write"
    # ```
    #
    # With the `WritingAdditions` required, you can now write files
    # by using `.write(file : String | Path | IO)`:
    #
    # NOTE: Writing a `WAD` creates new directories specific to that `WAD`,
    # meaning that while the `WAD::Directory#size` and the `WAD::Directory#file_pos`
    # are assigned automatically, you still have to make sure you [Make a New Directory](https://D-Shwagginz.github.io/wa-cr/Documentation/C_Usage/C_OnDirectories.html#making-new-directories)
    # when creating something new in the wad, or else that new something won't get written out.
    #
    # ```
    # require "wa-cr/write"
    #
    # my_string_wad.write("Path/To/MyWad.WAD")     # => The size of the written file in bytes
    # my_path_wad.write(Path["Path/To/MyWad.WAD"]) # => The size of the written file in bytes
    #
    # File.open("Path/To/MyWad.WAD", "w+") do |file|
    #   my_io_wad.write(file) # => The size of the written file in bytes
    # end
    # ```
    #
    # ### Note on WAD Lump Names
    #
    # When writing a `WAD`, a lump's name can be any length and contain any characters when read into or created in a `WAD`.<br>
    # However, when writing out a `WAD`, all lump names will have all instances
    # of any ms-dos [Incompatible Characters](https://en.wikipedia.org/wiki/8.3_filename#Directory_table:~:text=This%20excludes%20the%20following%20ASCII%20characters%3A)
    # replaced with "~" and the length of the name will be truncated to be no longer than 8 characters:
    #
    # ```
    # require "wa-cr/write"
    #
    # my_new_wad = WAD.new(WAD::Type::Internal)
    #
    # my_new_wad.add("My+New.Sound", "Sound", "Path/To/MySound.lmp")
    # my_new_wad.write("Path/To/MyWad.WAD")
    #
    # my_read_wad = WAD.read("Path/To/MyWad.WAD")
    #
    # my_read_wad.sounds.keys # => ["My~New~S"]
    # ```
    #
    # ### Writing lumps
    #
    # `WAD` and all of its sub-classes have a `.write` method:
    #
    # ```
    # require "wa-cr/write"
    #
    # my_sound.write("Path/To/MySound.lmp")
    # my_graphic.write("Path/To/MyGraphic.lmp")
    # ```
    #
    # Note that in order to write `WAD::Map` data, because the data is stored in arrays,
    # you use a class method and input the file and the array to write:
    #
    # ```
    # require "wa-cr/write"
    #
    # my_things = [WAD::Map.thing.new, WAD::Map.thing.new]     # => Creates an array of two map things
    # WAD::Map::Thing.write("Path/To/MyThings.lmp", my_things) # => Returns the directory of the written file
    #
    # my_linedefs = [WAD::Map.linedef.new, WAD::Map.linedef.new]     # => Creates an array of two map linedefs
    # WAD::Map::Linedef.write("Path/To/MyLinedefs.lmp", my_linedefs) # => Returns the directory of the written file
    # ```
    #
    # When writing any map data, the `.write` method will always return the directory of the written file,
    # not the size of it. This is because the name of the data will always be the same,
    # "THINGS" for a things lump, "LINEDEFS" for a linedefs lump, etc.
    #
    # To get the size of the directory, refer to `WAD::Directory`'s `WAD::Directory#size` variable
    # NOTE: The `WAD::Directory#file_pos` of the written map data's
    # directory will always equal 0 when it is written to a .lmp file
    module F_WritingFiles
    end
  end
end
