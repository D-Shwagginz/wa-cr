require "bit_array"
require "debug"

{% if flag?(:debug) %}
  Debug.enabled = true
{% end %}

# ### Reading a .WAD file's data
#
# To simply read in a WAD file, you just call `WAD.read(file : Path | String | IO) : WAD`:
#
# ```
# my_string_wad = WAD.read("Path/To/Wad")
# my_path_wad = WAD.read(Path["Path/To/Wad"])
#
# File.open("Path/To/Wad") do |file|
#   my_io_wad = WAD.read(file)
# end
# ```
#
# ### Creating a new `WAD`
#
# To create a new `WAD`, you call `WAD.new(type)`, with type being of `WAD::Type`
#
# ```
# my_new_internal_wad = WAD.new(WAD::Type::Internal)
# my_new_patch_wad = WAD.new(WAD::Type::Patch)
# ```
#
# ### Using the `WAD`'s data
#
# wa-cr sorts the the parsed wad's data into easy to use variables.
#
# To get the sample rate of the sound *"MYSOUND"*:
#
# ```
# my_wad.sounds["MYSOUND"].sample_rate # => returns the sample rate of the sound
# ```
#
# To get *y_position* of the 34th thing in the map *"MAP23"*:
#
# ```
# # Gets the thing index 33 because it is zero indexed: the 33rd index is the 34th thing
# my_wad.maps["MAP23"].things[33].y_position # => returns the y_position of the thing
# ```
#
# ### Lumps
#
# You can also read in .lmp lump files:
#
# NOTE: `Graphic.parse` can take 2 arguments: The file to read and
# the position of the start of the data (Default is -1. Should almost always be -1 when reading a .lmp)
# ```
# my_string_graphic = WAD::Graphic.parse("Path/To/MyGraphic.lmp")
# my_path_graphic = WAD::Graphic.parse(Path["Path/To/MyGraphic.lmp"])
#
# File.open("Path/To/MyGraphic.lmp") do |file|
#   my_io_graphic = WAD::Graphic.parse(file)
# end
# ```
# ```
# my_string_flat = WAD::Flat.parse("Path/To/MyFlat.lmp")
# my_path_flat = WAD::Flat.parse(Path["Path/To/MyFlat.lmp"])
#
# File.open("Path/To/MyFlat.lmp") do |file|
#   my_io_flat = WAD::Flat.parse(file)
# end
# ```
# ```
# my_string_sound = WAD::Sound.parse("Path/To/MySound.lmp")
# my_path_sound = WAD::Sound.parse(Path["Path/To/MySound.lmp"])
#
# File.open("Path/To/MySound.lmp") do |file|
#   my_io_sound = WAD::Sound.parse(file)
# end
# ```
class WAD
  # The size of the header in bytes
  HEADER_SIZE = 16
  # Type of WAD: Either Internal, IWAD, or Patch, PWAD.
  property type : Type = Type::Broken
  # An integer specifying the number of lumps in the WAD.
  property directories_count : UInt32 = 0_u32
  # An integer holding a pointer to the location of the directory.
  property directory_pointer : UInt32 = 0_u32
  # Array of maps in the WAD.
  property maps : Hash(String, Map) = {} of String => Map
  # Array of speaker sounds in the WAD.
  property pcsounds : Hash(String, PcSound) = {} of String => PcSound
  # Array of sounds in the WAD.
  property sounds : Hash(String, Sound) = {} of String => Sound
  # Array of music in the WAD.
  property music : Hash(String, Music) = {} of String => Music
  # The Genmidi in the WAD.
  property genmidi : Genmidi = Genmidi.new
  # The Dmxgus in the WAD.
  property dmxgus : Dmxgus = Dmxgus.new
  # The Playpal in the WAD.
  property playpal : Playpal = Playpal.new
  # The Colormap in the WAD.
  property colormap : Colormap = Colormap.new
  # The Endoom in the WAD.
  property endoom : EnDoom = EnDoom.new
  # Array of texture maps in the WAD.
  property texmaps : Hash(String, TextureX) = {} of String => TextureX
  # The Pnames in the WAD.
  property pnames : Pnames = Pnames.new
  # Array of Graphics and patches in the WAD.
  property graphics : Hash(String, Graphic) = {} of String => Graphic
  # Array of Sprites in the WAD.
  property sprites : Hash(String, Graphic) = {} of String => Graphic
  # Array of Flats in the WAD.
  property flats : Hash(String, Flat) = {} of String => Flat
  # Array of Demos in the WAD.
  property demos : Hash(String, Demo) = {} of String => Demo
  # Array of all directories in the WAD.
  property directories : Array(Directory) = [] of Directory

  def initialize(@type : Type = Type::Broken)
  end

  # :nodoc:
  # Macro that parses a given *name* for a map.
  # WARNING: Only use at the end of self.read with *name* being a .map parse method
  # and *class_name* being the name of the class in *Map*.
  macro map_parse(name, class_name)
    file.read_at(map.{{name}}_directory.file_pos, map.{{name}}_directory.size) do |io|
      map.{{name}} = Map::{{class_name}}.parse(io, map.{{name}}_directory.size)
    end
  end

  # Creates a new empty directory with *name* and puts it onto the list of directories.
  # WARNING: Directory will not work if *name* is not the correct name of the data
  #
  # ```
  # File.open("Path/To/MySound.lmp", "w+") do |file|
  #   my_wad.["MYSOUND"] = WAD::Sound.parse(file)
  #   my_wad.new_dir("MYSOUND")
  # end
  # ```
  def new_dir(name : String)
    directory = WAD::Directory.new
    directory.name = name
    directories << directory
  end

  # Type of WAD: Broken if not Internal, IWAD, or Patch, PWAD.
  enum Type
    Broken
    Internal
    Patch
  end

  # An enum for all types that can be added to the `WAD` by using `WAD#add`
  enum AddTypes
    PcSound
    Sound
    Music
    TextureX
    Graphic
    Flat
    Demo
  end

  # Allows easy parsing of lumps into the WAD
  #
  # ```
  # my_wad = WAD.new(WAD::Type::Internal)
  #
  # my_wad.add("MyTest", WAD::AddTypes::Sound, "Path/To/SoundTest.lmp")
  # ```
  #
  def add(name : String, type : AddTypes, file : Path | String)
    File.open(file) do |io|
      add(name, type, io)
    end
  end

  # Allows easy parsing of lumps into the WAD
  #
  # ```
  # my_wad = WAD.new(WAD::Type::Internal)
  #
  # File.open("Path/To/Sound.lmp") do |file|
  #   my_wad.add("MyTest", WAD::AddTypes::Sound, file)
  # end
  # ```
  #
  def add(name : String, type : AddTypes, file : IO)
    case type
    when AddTypes::PcSound
      pcsounds[name] = PcSound.parse(file)
      new_dir(name)
    when AddTypes::Sound
      sounds[name] = Sound.parse(file)
      new_dir(name)
    when AddTypes::Music
      music[name] = Music.parse(file)
      new_dir(name)
    when AddTypes::TextureX
      texmaps[name] = TextureX.parse(file)
      new_dir(name)
    when AddTypes::Graphic
      Graphic.parse(file).try do |graphic|
        graphics[name] = graphic
        new_dir(name)
      end
    when AddTypes::Flat
      flats[name] = Flat.parse(file)
      new_dir(name)
    when AddTypes::Demo
      demos[name] = Demo.parse(file)
      new_dir(name)
    else
      raise "#{type} IS AN INVALID TYPE"
    end
  end

  # Reads in a WAD file given the *io*:
  #
  # ```
  # File.open("Path/To/Wad") do |file|
  #   my_wad = WAD.read(file)
  # end
  # ```
  def self.read(file : IO, *, throw_errors : Bool = false) : WAD
    invalid_lump_found = false
    wad = WAD.new
    start_pos = file.pos.to_u32
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
    wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian) + start_pos
    # Index of the current directory.
    d_index = 0

    # Parses each directory in WAD.
    # OPTIMIZE: Rework to remove *d_index* and replace with *wad.directories_count.times*.
    while d_index < wad.directories_count
      # Shows if the directory has been read
      directory_read = false

      # The start of the directory
      directory_start = wad.directory_pointer + (d_index*Directory::SIZE)
      # Reads the directory at *directory_start* of *Directory::Size*.
      file.read_at(directory_start, Directory::SIZE) do |io|
        # Reads directory *io* and pushes it onto *wad.directories*.
        directory = Directory.read(io, start_pos)
        wad.directories << directory

        if !directory_read
          # Parses map if *directory.name* is of format 'ExMx' or 'MAPxx' .
          begin
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
                  directory = Directory.read(io, start_pos)
                  # Checks if it has reached the end of the map's lumps
                  # By seeing if the *directory.name* is a map, showing
                  # it reached the next map.
                  if !Map::MAP_CONTENTS.includes?(directory.name)
                    d_index -= 1
                    map_directory_end_reached = true
                    break
                  end
                  # Inserts the directory into the map.
                  map.insert_next_property(directory)
                end
              end

              # Parses each map lump into *map*.
              map_parse(things, Thing)
              map_parse(linedefs, Linedef)
              map_parse(sidedefs, Sidedef)
              map_parse(vertexes, Vertex)
              map_parse(segs, Seg)
              map_parse(ssectors, Ssector)
              map_parse(nodes, Node)
              map_parse(sectors, Sector)
              file.read_at(map.reject_directory.file_pos, map.reject_directory.size) do |io|
                map.reject = Map::Reject.parse(io, map.reject_directory.size, map.sectors.size)
              end
              map_parse(blockmap, Blockmap)

              # Pushes map onto the list of maps
              wad.maps[map.name] = map
              directory_read = true
            end
          rescue e
            raise "MAP '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses pc sound if *directory.name* is of format 'DPx..x'
          begin
            if PcSound.is_pcsound?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.pcsounds[directory.name] = PcSound.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "PC SOUND '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses sound if *directory.name* is of format 'DSx..x'
          begin
            if Sound.is_sound?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.sounds[directory.name] = Sound.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "SOUND '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses music if *directory.name* is of format 'D_x..x'
          begin
            if Music.is_music?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.music[directory.name] = Music.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "MUSIC '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses genmidi if *directory.name* is "GENMIDI"
          begin
            if Genmidi.is_genmidi?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.genmidi = Genmidi.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "GENMIDI '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses dmxgus if *directory.name* is "DMXGUS"
          begin
            if Dmxgus.is_dmxgus?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.dmxgus = Dmxgus.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "DMXGUS '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses playpal if *directory.name* is "PLAYPAL"
          begin
            if Playpal.is_playpal?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.playpal = Playpal.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "PLAYPAL '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses colormap if *directory.name* is "COLORMAP"
          begin
            if Colormap.is_colormap?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.colormap = Colormap.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "COLORMAP '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses texture map if *directory.name* is "TEXTUREx"
          begin
            if TextureX.is_texturex?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.texmaps[directory.name] = TextureX.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "TEXTURE MAP '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses EnDoom if *directory.name* is "ENDOOM"
          begin
            if EnDoom.is_endoom?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.endoom = EnDoom.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "ENDOOM '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses Pnames if *directory.name* is "PNAMES"
          begin
            if Pnames.is_pnames?(directory.name)
              file.read_at(directory.file_pos, directory.size) do |io|
                wad.pnames = Pnames.parse(io)
                directory_read = true
              end
            end
          rescue e
            raise "PNAMES '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses sprites if *directory.name* is "S_START".
          begin
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
                  directory = Directory.read(io, start_pos)
                  wad.directories << directory
                  # Checks if it has reached the end of the map's lumps
                  # By seeing if the *directory.name* is a map, showing
                  # it reached the next map.
                  if Graphic.is_sprite_mark_end?(directory.name)
                    sprite_directory_end_reached = true
                    break
                  end
                  # Parses Sprite if the size is the correct size of the lump
                  Graphic.parse(file, directory.file_pos, directory.size).try do |graphic|
                    wad.sprites[directory.name] = graphic
                  end
                end
              end
              directory_read = true
            end
          rescue e
            raise "SPRITE '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses flats if *directory.name* is "F_START".
          begin
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
                  directory = Directory.read(io, start_pos)
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
                      wad.flats[directory.name] = Flat.parse(io)
                    rescue e : IO::EOFError
                    end
                  end
                end
              end
              directory_read = true
            end
          rescue e
            raise "FLAT '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses Graphic if the size is the correct size of the lump
          begin
            Graphic.parse(file, directory.file_pos, directory.size).try do |graphic|
              wad.graphics[directory.name] = graphic
              directory_read = true
            end
          rescue e
            raise "GRAPHIC '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        if !directory_read
          # Parses Demo if the first byte is == 109, showing the doom version
          begin
            file.read_at(directory.file_pos, directory.size) do |is_demo_io|
              if Demo.is_demo?(is_demo_io)
                file.read_at(directory.file_pos, directory.size) do |io|
                  wad.demos[directory.name] = Demo.parse(io)
                  directory_read = true
                end
              end
            end
          rescue e
            raise "DEMO '#{directory.name}' IS INVALID\n#{e}" if throw_errors
            invalid_lump_found = true
          end
        end

        # Iterates the directory index.
        d_index += 1
      end
    end
    puts "WARNING: Invalid lump(s) encountered but skipped" if invalid_lump_found
    wad
  end

  # Reads in a WAD file given the *filename*:
  #
  # ```
  # my_wad = WAD.read("Path/To/Wad")
  # ```
  def self.read(filename : Path | String) : WAD
    # Opens the *filename* and sets according things.
    File.open(filename) do |file|
      return read(file)
    end

    raise "WAD invalid"
  end

  # Reads in a WAD file given the *io*
  # but returns `Nil` if parsing the `WAD` throws an error:
  #
  # ```
  # File.open("Path/To/Wad") do |file|
  #   my_wad = WAD.read?(file)
  # end
  # ```
  def self.read?(file : IO) : WAD | Nil
    begin
      return self.read(file, throw_errors: true)
    rescue
      return nil
    end
  end

  # Reads in a WAD file given the *filename*
  # but returns `Nil` if parsing the `WAD` throws an error:
  #
  # ```
  # my_wad = WAD.read?("Path/To/Wad")
  # ```
  def self.read?(filename : Path | String) : WAD | Nil
    # Opens the *filename* and sets according things.
    File.open(filename) do |file|
      return read?(file)
    end

    raise "WAD invalid"
  end

  # Reads in a WAD file given the *io*
  # but returns all errors thrown when parsing lumps:
  #
  # ```
  # File.open("Path/To/Wad") do |file|
  #   my_wad = WAD.read!(file)
  # end
  # ```
  def self.read!(file : IO) : WAD
    return self.read(file, throw_errors: true)
  end

  # Reads in a WAD file given the *filename*
  # but returns all errors thrown when parsing lumps:
  #
  # ```
  # my_wad = WAD.read!("Path/To/Wad")
  # ```
  def self.read!(filename : Path | String) : WAD
    # Opens the *filename* and sets according things.
    File.open(filename) do |file|
      return read!(file)
    end

    raise "WAD invalid"
  end

  # Cuts a string down to length *len* if it is larger than *len*:
  #
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

  # Replaces all instances of ms-dos name incompatible chars of a string with "~":
  #
  # ```
  # my_string = "My.TestString"
  # WAD.string_sub_chars(my_string) # => "My~Test~String"
  # ```
  def self.string_sub_chars(string : String) : String
    incompatible_chars = ['"', '*', '+', '.', ',', '/', ':', ';', '<', '=', '>', '?', '\\', '[', ']', '|']
    new_string = string

    incompatible_chars.each do |char|
      new_string = new_string.gsub(char, '~')
    end
    return new_string
  end

  # Cuts a slice down to length *len* if it is larger than *len*:
  #
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
