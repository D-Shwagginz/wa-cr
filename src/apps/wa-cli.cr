require "./wa-cli/**"
require "../wa-cr"
require "../write"
require "clim"
require "crysterm"

module Apps
  module WaCli
    VERSION = "0.1.0"

    alias C = Crysterm

    class Parser < Clim
      main do
        desc "DFL CLI tool."
        usage "dfl [options] [arguments]"
        help short: "-h"
        version "Version #{VERSION}", short: "-v"
        option "-e", "--errors", type: Bool, desc: "Lists all of the error codes."
        option "-l", "--list", type: Bool, desc: "Lists all of the portions in the dfl."
        argument "file-location", type: String, desc: ".dfl or .dpo file location."
        run do |opts, args|
          if opts.errors
            Errors.each do |error|
              puts "#{error.value} | #{error} | #{ErrorCodes[error]}"
            end
            exit
          end

          if args.file_location.nil?
            WaCli.put_error(Errors::NoFileGiven)
            exit(1)
          end

          WaCli.run(args.file_location.as(String))
        end
      end
    end
  end

  WaCli::Parser.start(ARGV)
end
