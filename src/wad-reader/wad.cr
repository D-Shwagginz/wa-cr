require "bit_array"

require "./directory"
require "./map"

# Raw WAD
class WAD
  # Parses a given X for a map
  macro map_parse(name)
    file.read_at(map.{{name}}_directory.file_pos, map.{{name}}_directory.size) do |io|
      map.{{name}} = Map.parse_{{name}}(io, map.{{name}}_directory)
    end
  end

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
            map_directory_end_reached = false
            until (map_directory_end_reached)
              d_index += 1
              directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
              break if directory_start + Directory::SIZE > wad.directory_pointer + (wad.directories_count*Directory::SIZE)
              file.read_at(directory_start, Directory::SIZE) do |io|
                directory = Directory.read(io, d_index)
                if Map.is_map? directory.name
                  d_index -= 1
                  map_directory_end_reached = true
                  break
                end
                map.insert_next_property(directory)
              end
            end

            map_parse(things)
            map_parse(linedefs)
            map_parse(sidedefs)
            map_parse(vertexes)
            map_parse(segs)
            map_parse(ssectors)
            map_parse(nodes)
            map_parse(sectors)

            file.read_at(map.reject_directory.file_pos, map.reject_directory.size) do |io|
              map.reject = Map.parse_reject(io, map.reject_directory, map.sectors.size)
            end

            map_parse(blockmap)

            # file.read_at(map.things_directory.file_pos, map.things_directory.size) do |io|
            #   map.things = Map.parse_things(io, map.things_directory)
            # end

            # file.read_at(map.linedefs_directory.file_pos, map.linedefs_directory.size) do |io|
            #   map.linedefs = Map.parse_linedefs(io, map.linedefs_directory)
            # end

            # file.read_at(map.sidedefs_directory.file_pos, map.sidedefs_directory.size) do |io|
            #   map.sidedefs = Map.parse_sidedefs(io, map.sidedefs_directory)
            # end

            # file.read_at(map.vertexes_directory.file_pos, map.vertexes_directory.size) do |io|
            #   map.vertexes = Map.parse_vertexes(io, map.vertexes_directory)
            # end

            # file.read_at(map.segs_directory.file_pos, map.segs_directory.size) do |io|
            #   map.segs = Map.parse_segs(io, map.segs_directory)
            # end

            # file.read_at(map.ssectors_directory.file_pos, map.ssectors_directory.size) do |io|
            #   map.ssectors = Map.parse_ssectors(io, map.ssectors_directory)
            # end

            # file.read_at(map.nodes_directory.file_pos, map.nodes_directory.size) do |io|
            #   map.nodes = Map.parse_nodes(io, map.nodes_directory)
            # end

            # file.read_at(map.sectors_directory.file_pos, map.sectors_directory.size) do |io|
            #   map.sectors = Map.parse_sectors(io, map.sectors_directory)
            # end

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
