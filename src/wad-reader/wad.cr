require "bit_array"
require "debug"

{% if flag?(:debug) %}
  Debug.enabled = true
{% end %}

# Reads and stores the data of a WAD file.
class WAD
  # The size of the header in bytes
  HEADER_SIZE = 16
  # Type of WAD: Either IWAD, PWAD, or Broken.
  property type : Type = Type::Broken
  # The file/WAD name and directory.
  property filename = ""
  # An integer specifying the number of lumps in the WAD.
  property directories_count = 0_u32
  # An integer holding a pointer to the location of the directory.
  property directory_pointer = 0_u32
  # Array of maps in the WAD.
  property maps = {} of String => Map
  # Array of speaker sounds
  property pcsounds = {} of String => PcSound
  # Array of sounds
  property sounds = {} of String => Sound
  # Array of music
  property music = {} of String => Music
  # Genmidi
  property genmidi : Genmidi = Genmidi.new
  # Dmxgus
  property dmxgus : Dmxgus = Dmxgus.new
  # Playpal
  property playpal : Playpal = Playpal.new
  # Colormap
  property colormap : Colormap = Colormap.new
  # Endoom
  property endoom : EnDoom = EnDoom.new
  # The texture maps
  property texmaps = {} of String => TextureX
  # Pnames
  property pnames : Pnames = Pnames.new
  # Graphics and patches
  property graphics = {} of String => Graphic
  # Sprites
  property sprites = {} of String => Graphic
  # Flats
  property flats = {} of String => Flat
  # Demos
  property demos = {} of String => Demo
  # Array of all directories in the WAD.
  property directories = [] of Directory

  # :nodoc:
  # Macro that parses a given *name* for a map.
  # WARNING: Only use at the end of self.read with *name* being a .map parse method
  # and *class_name* being the name of the class in *Map*.
  macro map_parse(name, class_name)
    file.read_at(map.{{name}}_directory.file_pos, map.{{name}}_directory.size) do |io|
      map.{{name}} = Map::{{class_name}}.parse(io, map.{{name}}_directory.size)
    end
  end

  # Type of WAD: Broken if not Internal, IWAD, or Patch, PWAD.
  enum Type
    Broken
    Internal
    Patch
  end

  # Reads in a WAD file given the *filename*.
  #
  # Example:
  # ```
  # mywad = WAD.read("Path/To/Wad")
  # ```
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
            map = Map.new(directory.name)
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
                directory = Directory.read(io)
                # Checks if it has reached the end of the map's lumps
                # By seeing if the *directory.name* is a map, showing
                # it reached the next map.
                if Map.is_map?(directory.name)
                  d_index -= 1
                  map_directory_end_reached = true
                  break
                elsif !Map::MAP_CONTENTS.includes?(directory.name)
                  map_directory_end_reached = true
                  wad.directories << directory
                  break
                end
                # Inserts the directory into the map.
                map.insert_next_property(directory)
              end
            end

            # Parses each map lump into *map*.
            map_parse(things, Things)
            map_parse(linedefs, Linedefs)
            map_parse(sidedefs, Sidedefs)
            map_parse(vertexes, Vertexes)
            map_parse(segs, Segs)
            map_parse(ssectors, Ssectors)
            map_parse(nodes, Nodes)
            map_parse(sectors, Sectors)
            file.read_at(map.reject_directory.file_pos, map.reject_directory.size) do |io|
              map.reject = Map::Reject.parse(io, map.reject_directory.size, map.sectors.size)
            end
            map_parse(blockmap, Blockmap)

            # Pushes map onto the list of maps
            wad.maps[map.name] = map
          end

          # Parses pc sound if *directory.name* is of format 'DPx..x'
          if PcSound.is_pcsound?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.pcsounds[directory.name] = PcSound.parse(io, directory.name)
            end
          end

          # Parses sound if *directory.name* is of format 'DSx..x'
          if Sound.is_sound?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.sounds[directory.name] = Sound.parse(io)
            end
          end

          # Parses music if *directory.name* is of format 'D_x..x'
          if Music.is_music?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.music[directory.name] = Music.parse(io)
            end
          end

          # Parses genmidi if *directory.name* is "GENMIDI"
          if Genmidi.is_genmidi?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.genmidi = Genmidi.parse(io)
            end
          end

          # Parses dmxgus if *directory.name* is "DMXGUS"
          if Dmxgus.is_dmxgus?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.dmxgus = Dmxgus.parse(io)
            end
          end

          # Parses playpal if *directory.name* is "PLAYPAL"
          if Playpal.is_playpal?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.playpal = Playpal.parse(io)
            end
          end

          # Parses colormap if *directory.name* is "COLORMAP"
          if Colormap.is_colormap?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.colormap = Colormap.parse(io)
            end
          end

          # Parses texture map if *directory.name* is "TEXTUREx"
          if TextureX.is_texturex?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.texmaps[directory.name] = TextureX.parse(io)
            end
          end

          # Parses EnDoom if *directory.name* is "ENDOOM"
          if EnDoom.is_endoom?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.endoom = EnDoom.parse(io)
            end
          end

          # Parses Pnames if *directory.name* is "PNAMES"
          if Pnames.is_pnames?(directory.name)
            file.read_at(directory.file_pos, directory.size) do |io|
              wad.pnames = Pnames.parse(io)
            end
          end

          # Parses sprites if *directory.name* is "S_START".
          if Graphic.is_sprite_mark_start?(directory.name)
            # Creates a variable to show that the directory has ended.
            # and runs until the end has been reached.
            sprite_directory_end_reached = false
            until (sprite_directory_end_reached)
              # Iterates the directory index.
              d_index += 1
              # The start of the directory.
              directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
              # Breaks if the the end of the directory is greater than the end of the WAD's total directories.
              break if directory_start + Directory::SIZE > wad.directory_pointer + (wad.directories_count*Directory::SIZE)
              # Reads the directory at *directory_start* of *Directory::Size*.
              file.read_at(directory_start, Directory::SIZE) do |io|
                # Reads directory *io* and pushes it onto *wad.directories*.
                directory = Directory.read(io)
                wad.directories << directory
                # Checks if it has reached the end of the map's lumps
                # By seeing if the *directory.name* is a map, showing
                # it reached the next map.
                if Graphic.is_sprite_mark_end?(directory.name)
                  sprite_directory_end_reached = true
                  break
                end
                # Parses Sprite if the size is the correct size of the lump
                Graphic.parse(file, directory).try do |graphic|
                  wad.sprites[directory.name] = graphic
                end
              end
            end
          end

          # Parses flats if *directory.name* is "F_START".
          if Flat.is_flat_mark_start?(directory.name)
            # Creates a variable to show that the directory has ended.
            # and runs until the end has been reached.
            flat_directory_end_reached = false
            until (flat_directory_end_reached)
              # Iterates the directory index.
              d_index += 1
              # The start of the directory.
              directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
              # Breaks if the the end of the directory is greater than the end of the WAD's total directories.
              break if directory_start + Directory::SIZE > wad.directory_pointer + (wad.directories_count*Directory::SIZE)
              # Reads the directory at *directory_start* of *Directory::Size*.
              file.read_at(directory_start, Directory::SIZE) do |io|
                # Reads directory *io* and pushes it onto *wad.directories*.
                directory = Directory.read(io)
                wad.directories << directory
                # Checks if it has reached the end of the map's lumps
                # By seeing if the *directory.name* is a map, showing
                # it reached the next map.
                if Flat.is_flat_mark_end?(directory.name)
                  flat_directory_end_reached = true
                  break
                end
                # Parses Flat
                file.read_at(directory.file_pos, directory.size) do |io|
                  begin
                    wad.flats[directory.name] = Flat.parse(io, directory.name)
                  rescue e : IO::EOFError
                  end
                end
              end
            end
          end

          # Parses Graphic if the size is the correct size of the lump
          Graphic.parse(file, directory).try do |graphic|
            wad.graphics[directory.name] = graphic
          end

          # Parses Demo if the first byte is == 109, showing the doom version
          file.read_at(directory.file_pos, directory.size) do |is_demo_io|
            if Demo.is_demo?(is_demo_io)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.demos[directory.name] = Demo.parse(io)
              end
            end
          end

          # Iterates the directory index.
          d_index += 1
        end
      end
    end
    # Returns the read parsed file.
    wad
  end

  # Cuts a string down to length *len* if it is larger than *len*
  #
  # Example:
  # ```
  # WAD.string_cut("Aberdine", 4) # => "Aber"
  # ```
  def self.string_cut(string : String, len : Int = 8) : String
    if string.size > len
      return string[0..(len - 1)]
    else
      return string
    end
  end

  # Cuts a slice down to length *len* if it is larger than *len*
  #
  # Example:
  # ```
  # my_slice = "My Test Slice".to_slice # => Bytes[77, 121, 32, 84, 101, 115, 116, 32, 83, 108, 105, 99, 101]
  # WAD.slice_cut(my_slice, 5)          # => Bytes[77, 121, 32, 84, 101]
  # ```
  def self.slice_cut(slice : Slice, len : Int = 8) : Slice
    if slice.size > len
      return slice[0..(len - 1)]
    else
      return slice
    end
  end
end
