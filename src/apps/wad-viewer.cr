require "../wa-cr"
require "../write"
require "../raylib"
require "./wad-viewer/**"
require "option_parser"
require "raylib-cr/raygui"

module Apps
  module WadViewer
    def self.run_cli
      wad_file : String = ""

      OptionParser.parse do |parser|
        parser.banner = "Usage: shards run map-viewer -- -w Path/To/MyWad.wad"

        parser.on("-w WAD", "--wad=WAD", "Sets the .wad for map-viewer to use") { |input_wad| wad_file = input_wad }

        parser.on("-h", "--help", "Shows this help") do
          puts parser
          exit
        end

        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          exit(1)
        end
      end

      raise "Wad Viewer requires a .wad file input by using `map-viewer -w Path/To/Wad`" if wad_file == ""

      Apps::WadViewer.run(wad_file)
    end
  end
end
