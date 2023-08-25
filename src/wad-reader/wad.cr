# Raw WAD
class WAD
  # WAD Directory
  class Directory
    # An integer holding a pointer to the start of the lump's data in the file.
    property file_pos = 0_u32
    # Index of file in the WAD.
    property index_in_wad = 0_i32
    # An integer representing the size of the lump in bytes.
    property size = 0_u32
    # An ASCII string defining the lump's name.
    property name = ""

    # Read an io from the WAD and convert it into a Directory.
    def self.read(io, index = 0) : Directory
      directory = Directory.new
      directory.file_pos = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.size = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.name = io.gets(8).to_s.gsub("\u0000", "")
      directory.index_in_wad = index
      directory
    end
  end

  # Map containing all directories of data lumps.
  class Map
    property name = ""
    property things = Directory.new
    property linedefs = Directory.new
    property sidedefs = Directory.new
    property vertexes = Directory.new
    property segs = Directory.new
    property ssectors = Directory.new
    property nodes = Directory.new
    property sectors = Directory.new
    property reject = Directory.new
    property blockmap = Directory.new

    # Times that a property has been inserted.
    @times_inserted = 0

    # Inserts a property into the map based off *times_inserted*.
    def insert_next_property(prop)
      case @times_inserted
      when 0
        @things = prop
      when 1
        @linedefs = prop
      when 2
        @sidedefs = prop
      when 3
        @vertexes = prop
      when 4
        @segs = prop
      when 5
        @ssectors = prop
      when 6
        @nodes = prop
      when 7
        @sectors = prop
      when 8
        @reject = prop
      when 9
        @blockmap = prop
      end
      @times_inserted += 1
    end
  end

  # Reads in a WAD file.
  def self.read(filename) : WAD
    wad = WAD.new
    wad.filename = filename
    File.open(filename) do |file|
      # Sets the header. Can only be the ASCII characters "IWAD" or "PWAD".
      header_slice = Bytes.new(4)
      file.read(header_slice)
      type = String.new(header_slice)
      # An integer specifying the number of lumps in the WAD.
      wad.directories_count = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # An integer holding a pointer to the location of the directory.
      wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # Index of the current directory.
      d_index = 0

      while d_index < wad.directories_count
        file.read_at(wad.directory_pointer + (d_index*16), 16) do |io|
          d_index += 1
          directory = Directory.read(io)
          wad.directories << directory
          if directory.name =~ /^E\dM\d/ || directory.name =~ /MAP\d\d/
            map = Map.new
            map.name = directory.name
            10.times do
              file.read_at(wad.directory_pointer + (d_index*16), 16) do |io|
                wad.directory_pointer + (d_index*16)
                map.insert_next_property(Directory.read(io, d_index))
                d_index += 1
              end
            end
            wad.maps << map
          end
        end
      end
    end
    wad
  end

  # Type of WAD. Either "IWAD" or "PWAD"
  property type = ""
  # The file/WAD name and directory.
  property filename = ""
  # An integer specifying the number of lumps in the WAD.
  property directories_count = 0_u32
  # An integer holding a pointer to the location of the directory.
  property directory_pointer = 0_u32
  # Array of maps in the WAD
  property maps = [] of Map
  # Array of all directories in the WAD
  property directories = [] of Directory
end
