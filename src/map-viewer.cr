require "./wa-cr"
require "./raylib"
require "./map-viewer/**"
require "option_parser"

wad : String = ""
map : String = ""

OptionParser.parse do |parser|
  parser.banner = "Usage: shards run map-viewer -- -w Path/To/MyWad.wad -m E1M1"

  parser.on("-w WAD", "--wad=WAD", "Sets the .wad for map-viewer to use") { |input_wad| wad = input_wad }

  parser.on("-m MAP", "--map=MAP", "Sets the map for map-viewer to use") { |input_map| map = input_map }

  parser.on("-h", "--help", "Shows this help") do
    puts parser
    exit
  end

  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    exit(1)
  end
end

MapViewer.run(wad, map)
