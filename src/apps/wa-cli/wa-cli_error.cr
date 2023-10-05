module Apps
  module WaCli
    enum Errors
      FileNotFound = 1
      NoFileGiven
    end

    ErrorCodes = {
      Errors::FileNotFound => "The given file location does not exist",
      Errors::NoFileGiven  => "No file location given",
    }

    def self.put_error(error : Errors)
      puts "ERROR: #{error.value} | #{error} | #{ErrorCodes[error]}"
    end
  end
end
