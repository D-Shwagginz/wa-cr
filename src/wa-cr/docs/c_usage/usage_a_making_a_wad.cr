module A_Overview
  module C_Usage
    # You can make a `WAD` by either creating a new one or reading a .wad file in.<br>
    # Note that when creating a new `WAD`, you'll need to put its `WAD::Type` in:
    #
    # ```
    # my_new_internal_wad = WAD.new(WAD::Type::Internal)
    # my_new_patch_wad = WAD.new(WAD::Type::Patch)
    # ```
    #
    # Note the overloads of `WAD.read(file : String | Path | IO)`.<br>
    # Many methods have similar overloads to allow interacting
    # with a file without having to open the file yourself:
    #
    # ```
    # File.open("Path/To/Wad") do |file|
    #   my_read_io_wad = WAD.read(file)
    # end
    #
    # # Overloads
    # my_read_string_wad = WAD.read("Path/To/Wad")
    # my_read_path_wad = WAD.read(Path["Path/To/Wad"])
    # ```
    module A_MakingAWad
    end
  end
end
