class WAD
  # A directory which points to a start of a lump with its size and name
  struct Directory
    SIZE = 16
    # An integer holding a pointer to the start of the lump's data in the file.
    property file_pos : UInt32 = 0_u32
    # An integer representing the size of the lump in bytes.
    property size : UInt32 = 0_u32
    # An ASCII string defining the lump's name.
    property name : String = ""

    # Read an io from the WAD and convert it into a Directory.
    #
    # Reads a directory from a WAD *file* with *directory_start* and *Directory::SIZE*:
    # ```
    # file.read_at(directory_start, Directory::SIZE) do |io|
    #   directory = Directory.read(io)
    # end
    # ```
    def self.read(io : IO, file_offset : UInt32 = 0) : Directory
      # Creates a new directory and sets all the properties
      directory = Directory.new
      directory.file_pos = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.file_pos += file_offset
      directory.size = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.name = io.gets(8).to_s.gsub("\u0000", "")
      directory
    end
  end
end
