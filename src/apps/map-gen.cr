require "../wa-cr"
require "../write"
require "./map-gen/**"
require "option_parser"

module Apps
  module MapGen
    def self.run_cli
      wad_file : String = ""
      seed : UInt64 = 0_u64

      OptionParser.parse do |parser|
        parser.banner = "Usage: map-viewer -w Path/To/MyWad.wad -s 35125642"

        parser.on("-w WAD", "--wad=WAD", "Sets the .wad name for map-gen to use") { |input_wad| wad_file = input_wad }

        parser.on("-s SEED", "--seed=SEED", "Sets the seed for map-gen to use") { |input_seed| seed = input_seed.to_u64 }

        parser.on("-h", "--help", "Shows this help") do
          puts parser
          exit
        end

        parser.invalid_option do |flag|
          STDERR.puts "ERROR: #{flag} is not a valid option."
          exit(1)
        end
      end

      raise "Map Gen requires a .wad file name by using `map-gen -w WadName`" if wad_file == ""

      Apps::MapGen.run(wad_file, seed)
    end
  end
end

Apps::MapGen.run_cli
