require "bit_array"

require "./directory"
require "./map"

# Raw WAD
class WAD
  enum Type
    Broken
    Internal
    Patch
  end

  def self.parse
    parsed_map.name = map.name
  end

  # Reads in a WAD file.
  def self.read(filename) : WAD
    wad = WAD.new
    wad.filename = filename
    File.open(filename) do |file|
      # Sets the header. Can only be the ASCII characters "IWAD" or "PWAD".
      header_slice = Bytes.new(4)
      file.read(header_slice)
      string_type = String.new(header_slice)
      if string_type =~ /^IWAD$/
        wad.type = Type::Internal
      elsif string_type =~ /^PWAD$/
        wad.type = Type::Patch
      else
        raise("TYPE IS BAD: #{string_type}")
      end
      # An integer specifying the number of lumps in the WAD.
      wad.directories_count = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # An integer holding a pointer to the location of the directory.
      wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # Index of the current directory.
      d_index = 0

      while d_index < wad.directories_count

        directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
        file.read_at(directory_start, Directory::SIZE) do |io|
          directory = Directory.read(io)
          wad.directories << directory

          if Map.is_map?(directory.name)
            map = Map.new
            map.name = directory.name
            directory = Directory.new
            loop do
              d_index += 1
              directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
              break if directory_start + Directory::SIZE > wad.directory_pointer + (wad.directories_count*Directory::SIZE)
              file.read_at(directory_start, Directory::SIZE) do |io|
                directory = Directory.read(io, d_index)
                break if Map.is_map? directory.name
                map.insert_next_property(directory)
              end
            end

            file.read_at(map.things_directory.file_pos, map.things_directory.size) do |io|
              map.things = Map.parse_things(io, map.things_directory)
            end

            map.linedefs = Map.parse_linedefs(wad, map.linedefs_directory)
            map.sidedefs = Map.parse_sidedefs(wad, map.sidedefs_directory)
            map.vertexes = Map.parse_vertexes(wad, map.vertexes_directory)
            map.segs = Map.parse_segs(wad, map.segs_directory)
            map.ssectors = Map.parse_ssectors(wad, map.ssectors_directory)
            map.nodes = Map.parse_nodes(wad, map.nodes_directory)
            map.sectors = Map.parse_sectors(wad, map.sectors_directory)

            wad.maps << map
          end
          d_index += 1
        end
      end
    end
    wad
  end

  # Type of WAD. Either "IWAD" or "PWAD"
  property type : Type = Type::Broken
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
