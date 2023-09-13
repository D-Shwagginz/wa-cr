module Documentation
  module C_Usage
    # wa-cr provides some apps to help with using and viewing `WAD` data.
    #
    # To use any of the following apps, you must require "wa-cr/apps"
    #
    # ```
    # require "wa-cr/apps"
    # ```
    #
    # Here is a quick reference list of all wa-cr apps:
    #
    #   - [MapViewer](https://sol-vin.github.io/wad-reader/Documentation/C_Usage/H_Apps.html#map-viewer)
    #
    # ### Map Viewer
    #
    # To use run the Map Viewer, use `Apps::MapViewer.run(wad, map)`:
    #
    # NOTE: *map* is not required. By default it will use the first map in the `WAD`
    #
    # ```
    # require "wa-cr/apps"
    #
    # my_wad = WAD.read("Path/To/Wad")
    #
    # Apps::MapViewer.run(my_wad, "MyMap")
    # ```
    #
    # The Map Viewer also provides a cli function `Apps::MapViewer.run_cli`:
    #
    # ```
    # require "wa-cr/apps"
    #
    # Apps::MapViewer.run_cli
    # ```
    #
    # To run this program, the command line would look something like this:
    #
    # ```
    # shards run -- -w Path/To/Wad -m MapName
    # ```
    module H_Apps
    end
  end
end
