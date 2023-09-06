module A_Overview
  module C_Usage
    # The `WAD` class provides a method to adding a new map to it's hash of maps.<br>
    # To create a new map in a `WAD`, just call `WAD#new_map(name)`:
    #
    # ```
    # my_new_wad = WAD.new(WAD::Type::Internal)
    #
    # my_new_wad.maps # => []
    # my_new_wad.new_map("MyNewMap")
    # my_new_wad.maps # => [{"MyNewMap" => WAD::Map}]
    #
    # my_new_wad.new_map("MySecondMap")
    # my_new_wad.maps # => [{"MyNewMap" => WAD::Map}, {"MySecondMap" => WAD::Map}]
    # ```
    #
    # With a new map created, you can add new map data to it:
    #
    # ```
    # my_new_thing = WAD::Map::Thing.new
    # my_new_wad.maps["MyNewMap"].things << my_new_thing
    #
    # my_new_linedef = WAD::Map::Linedef.new
    # my_new_wad.maps["MyNewMap"].linedefs << my_new_linedef
    # ```
    module F_MakingNewMaps
    end
  end
end
