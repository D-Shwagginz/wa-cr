require "bit_array"
require "./directory"
require "./map"

# Reads and stores the data of a WAD file.
class WAD
  # :nodoc:
  # Macro that parses a given *name* for a map.
  # WARNING: Only use at the end of self.read with *name* being a .map parse method.
  macro map_parse(name)
    file.read_at(map.{{name}}_directory.file_pos, map.{{name}}_directory.size) do |io|
      map.{{name}} = Map.parse_{{name}}(io, map.{{name}}_directory)
    end
  end

  # Type of WAD: Broken if not Internal, IWAD, or Patch, PWAD.
  enum Type
    Broken
    Internal
    Patch
  end

  # Reads in a WAD file given the *filename*.
  def self.read(filename) : WAD
    # Creates a new WAD variable with *filename*.
    wad = WAD.new
    wad.filename = filename

    # Opens the *filename* and sets according things.
    File.open(filename) do |file|
      # Sets the WAD type: Can only be the ASCII characters "IWAD" or "PWAD".
      header_slice = Bytes.new(4)
      file.read(header_slice)
      string_type = String.new(header_slice)

      # Sets WAD type to be Internal, Patch, or throws an exception with first four chars of WAD.
      if string_type =~ /^IWAD$/
        # Type is Internal, IWAD.
        wad.type = Type::Internal
      elsif string_type =~ /^PWAD$/
        # Type is Patch, PWAD.
        wad.type = Type::Patch
      else
        # Type is Broken.
        raise("TYPE IS BAD: #{string_type}")
      end

      # An integer specifying the number of lumps in the WAD.
      wad.directories_count = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # An integer holding a pointer to the start location of the directories.
      wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # Index of the current directory.
      d_index = 0

      # Parses each directory in WAD.
      # OPTIMIZE: Rework to remove *d_index* and replace with *wad.directories_count.times*.
      while d_index < wad.directories_count
        # The start of the directory
        directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
        # Reads the directory at *directory_start* of *Directory::Size*.
        file.read_at(directory_start, Directory::SIZE) do |io|
          # Reads directory *io* and pushes it onto *wad.directories*.
          directory = Directory.read(io)
          wad.directories << directory

          # Parses map if *directory.name* is of format 'ExMx' or 'MAPxx' .
          if Map.is_map?(directory.name)
            # Creates a new map variable with *directory.name*.
            map = Map.new
            map.name = directory.name
            # Creates a variable to show that the directory has ended.
            # and runs until the end has been reached.
            map_directory_end_reached = false
            until (map_directory_end_reached)
              # Iterates the directory index.
              d_index += 1
              # The start of the directory.
              directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
              # Breaks if the the end of the directory is greater than the end of the WAD's total directories.
              break if directory_start + Directory::SIZE > wad.directory_pointer + (wad.directories_count*Directory::SIZE)
              # Reads the directory at *directory_start* of *Directory::Size*.
              file.read_at(directory_start, Directory::SIZE) do |io|
                # Reads directory *io* and pushes it onto *wad.directories*.
                directory = Directory.read(io, d_index)
                # Checks if it has reached the end of the map's lumps
                # By seeing if the *directory.name* is a map, showing
                # it reached the next map.
                if Map.is_map? directory.name
                  d_index -= 1
                  map_directory_end_reached = true
                  break
                end
                # Inserts the directory into the map.
                map.insert_next_property(directory)
              end
            end

            # Parses each map lump into *map*.
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

            #
            wad.maps << map
          end
          # Iterates the directory index.
          d_index += 1
        end
      end
    end
    # Returns the read parsed file.
    wad
  end

  # Type of WAD: Either IWAD, PWAD, or Broken.
  property type : Type = Type::Broken
  # The file/WAD name and directory.
  property filename = ""
  # An integer specifying the number of lumps in the WAD.
  property directories_count = 0_u32
  # An integer holding a pointer to the location of the directory.
  property directory_pointer = 0_u32
  # Array of maps in the WAD.
  property maps = [] of Map
  # Array of all directories in the WAD.
  property directories = [] of Directory
end
