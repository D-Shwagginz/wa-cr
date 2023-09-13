require "../wa-cr"
require "../raylib"
require "./map-viewer/**"
require "option_parser"

module Apps
  # An app used for viewing maps
  #
  # To use, call `Apps::MapViewer.run(wad, map)`
  #
  # To use in the command line, call`Apps::MapViewer.run_cli`
  # and use `-w` and -m`
  module MapViewer
    # Runs the map viewer with *wad* and *map* defined in the command line
    # -w Path/To/Wad
    # -m MapName (not required)
    # -h (Shows the help)
    def self.run_cli
      wad_file : String = ""
      map : String = ""

      OptionParser.parse do |parser|
        parser.banner = "Usage: shards run map-viewer -- -w Path/To/MyWad.wad -m E1M1"

        parser.on("-w WAD", "--wad=WAD", "Sets the .wad for map-viewer to use") { |input_wad| wad_file = input_wad }

        parser.on("-m MAP", "--map=MAP", "Sets the map for map-viewer to use") { |input_map| map = input_map.upcase }

        parser.on("-h", "--help", "Shows this help") do
          puts parser
          exit
        end

        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          exit(1)
        end
      end

      raise "Map Viewer requires a .wad file input by using `map-viewer -w Path/To/Wad`" if wad_file == ""

      Apps::MapViewer.run(wad_file, map)
    end
  end
end
