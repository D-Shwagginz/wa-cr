require "./write/**"


# ### Additions to allow wa-cr to write to files
#
# To use these additions, just require it:
#
# ```
# require "wa-cr/write"
# ```
#
# Here's some examples of this addition:
#
# ```
# require "wa-cr/write"
#
# File.open("Path/To/Test.file") do |file|
#   # Writes a full wad
#   my_wad.write(file) # => Size of the written file
#
#   # Writes lumps return the size of the written lump
#   my_demo.write(file) # => Size of the written file
#
#   my_sound.write(file)   # => Size of the written file
#   my_pcsound.write(file) # => etc.
#
#   my_music.write(file) # => etc.
#   my_genmidi.write(file) # => etc.
#   my_dmxgus.write(file) # => etc.
#
#   my_playpal.write(file) # => etc.
#   my_colormap.write(file) # => etc.
#   my_endoom.write(file) # => etc.
#   my_texturemap.write(file) # => etc.
#   my_pnames.write(file) # => etc.
#   my_graphic.write(file) # => etc.
#   my_flat.write(file) # => etc.
# ```
#
# ### Map Data
#
#   To write specific map data, you have to use
#   the class methods and put in the file to
#   write, and the parsed map data you want to write:
#
# ```
# File.open("Path/To/Test.file") do |file|
#   my_map.write(file) # => An array of all written directories in the order listed below
#
#   Map::Thing.write(file, my_things : Array)              # => The written file's directory
#   Map::Linedef.write(file, my_linedefs : Array)          # => The written file's directory
#   Map::Sidedef.write(file, my_sidedefs : Array)          # => etc.
#   Map::Vertex.write(file, my_vertexs : Array)            # => etc.
#   Map::Seg.write(file, my_segs : Array)                  # => etc.
#   Map::Ssector.write(file, my_ssectors : Array)          # => etc.
#   Map::Node.write(file, my_nodes : Array)                # => etc.
#   Map::Sector.write(file, my_sectors : Array)            # => etc.
#   Map::Reject.write(file, my_reject : Map::Reject)       # => etc.
#   Map::Blockmap.write(file, my_blockmap : Map::Blockmap) # => etc.
# end
# ```
#
#
# ### Quick Writing
#
#   wa-cr's writing additions' methods also have overloads
#   to write to a file by just providing the file path
#
# ```
# # Writes a full wad
# my_wad.write("Path/To/File") # => Size of the written file
#
# # Writes lumps return the size of the written lump
# my_demo.write(file) # => Size of the written file
#
# my_sound.write("Path/To/File")   # => Size of the written file
# my_pcsound.write("Path/To/File") # => etc.
#
# my_music.write("Path/To/File")   # => etc.
# my_genmidi.write("Path/To/File") # => etc.
# my_dmxgus.write("Path/To/File")  # => etc.
#
# my_playpal.write("Path/To/File")    # => etc.
# my_colormap.write("Path/To/File")   # => etc.
# my_endoom.write("Path/To/File")     # => etc.
# my_texturemap.write("Path/To/File") # => etc.
# my_pnames.write("Path/To/File")     # => etc.
# my_graphic.write("Path/To/File")    # => etc.
# my_flat.write("Path/To/File")       # => etc.
#
# # Map Data
# my_map.write("Path/To/File") # => An array of all written directories in the order listed below
#
# Map::Thing.write("Path/To/File", my_thing : Array)             # => The written file's directory
# Map::Linedefwrite("Path/To/File", my_linedefs : Array)         # => The written file's directory
# Map::Sidedef.write("Path/To/File", my_sidedefs : Array)         # => etc.
# Map::Vertex.write("Path/To/File", my_vertexes : Array)         # => etc.
# Map::Seg.write("Path/To/File", my_segs : Array)                 # => etc.
# Map::Ssector.write("Path/To/File", my_ssectors : Array)         # => etc.
# Map::Node.write("Path/To/File", my_nodes : Array)               # => etc.
# Map::Sector.write("Path/To/File", my_sectors : Array)           # => etc.
# Map::Reject.write("Path/To/File", my_reject : Map::Reject)       # => etc.
# Map::Blockmap.write("Path/To/File", my_blockmap : Map::Blockmap) # => etc.
# ```
module WritingAdditions
  # Reads, writes, and stores the data of a WAD file.
  #
  # This helps write out parsed `::WAD` files to a .wad:
  #
  # ```
  # require "wa-cr/write"
  #
  # my_wad = WAD.read("Path/To/Wad")
  #
  # File.open("Path/To/MyWad.WAD", "w+") do |file|
  #   my_wad.write(file)
  # end
  # ```
  #
  # You can also write from new `::WAD` files:
  #
  # ```
  # require "wa-cr/write"
  #
  # my_wad = WAD.new
  #
  # # You'll need to set the WAD type for new WAD's
  # my_wad.type = WAD::Type::Internal
  #
  # File.open("Path/To/MyWad.WAD") do |file|
  #   my_wad.write(file)
  # end
  # ```
  module WAD
    # Writes a WAD class to an file and returns the written file's size
    #
    # Writes a wad file to *my_new_wad.WAD*:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # my_wad.write("Path/To/my_wad.WAD")
    # ```
    def write(file : String | Path) : UInt32
      File.open(file, "w+") do |file|
        return write(file)
      end
    end

    # Writes a WAD class to an io and returns the written file's size
    #
    # Writes a wad file to *my_new_wad.WAD*:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # File.open("Path/To/my_new_wad.WAD", "w+") do |file|
    #   my_wad.write(file)
    # end
    # ```
    def write(io : IO) : UInt32
      file_size : UInt32 = 0_u32
      written_directories : Array(::WAD::Directory) = [] of ::WAD::Directory
      write_directory_pointer : UInt32 = 0_u32

      _write_header(io)

      directories.each do |directory|
        written_directory = ::WAD::Directory.new
        written_directory.name = directory.name
        written_directory.file_pos = io.pos.to_u32

        if ::WAD::Genmidi.is_genmidi?(directory.name)
          written_directory.size = genmidi.write(io)
          written_directories << written_directory
          next
        end

        if ::WAD::Dmxgus.is_dmxgus?(directory.name)
          written_directory.size = dmxgus.write(io)
          written_directories << written_directory
          next
        end

        if ::WAD::Playpal.is_playpal?(directory.name)
          written_directory.size = playpal.write(io)
          written_directories << written_directory
          next
        end

        if ::WAD::Colormap.is_colormap?(directory.name)
          written_directory.size = colormap.write(io)
          written_directories << written_directory
          next
        end

        if ::WAD::EnDoom.is_endoom?(directory.name)
          written_directory.size = endoom.write(io)
          written_directories << written_directory
          next
        end

        if ::WAD::Pnames.is_pnames?(directory.name)
          written_directory.size = pnames.write(io)
          written_directories << written_directory
          next
        end

        if maps.[directory.name]?
          written_directory.size = 0
          written_directories << written_directory
          maps[directory.name].write(io).each do |lump_dir|
            written_directory = ::WAD::Directory.new
            written_directory.name = lump_dir.name
            written_directory.file_pos = lump_dir.file_pos
            written_directory.size = lump_dir.size
            written_directories << written_directory
          end
          next
        end

        if pcsounds.[directory.name]?
          written_directory.size = pcsounds[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if sounds.[directory.name]?
          written_directory.size = sounds[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if music.[directory.name]?
          written_directory.size = music[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if texmaps.[directory.name]?
          written_directory.size = texmaps[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if graphics.[directory.name]?
          written_directory.size = graphics[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if sprites.[directory.name]?
          written_directory.size = sprites[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if flats.[directory.name]?
          written_directory.size = flats[directory.name].write(io)
          written_directories << written_directory
          next
        end

        if demos.[directory.name]?
          written_directory.size = demos[directory.name].write(io)
          written_directories << written_directory
          next
        end

        written_directory.size = 0
        written_directories << written_directory
      end

      write_directory_pointer = io.pos.to_u32

      written_directories.each do |written_directory|
        _write_directory(io, written_directory)
      end

      file_size = io.pos.to_u32

      io.pos = 0

      _write_header(io, written_directories.size.to_u32, write_directory_pointer)
      file_size
    end

    private def _write_header(io : IO, directories_size : Int = 0, directory_pointer : Int = 0)
      case type
      when ::WAD::Type::Internal
        io.print("IWAD")
      when ::WAD::Type::Patch
        io.print("PWAD")
      else
        raise "WAD Type is #{type} not Internal or Patch"
      end
      io.write_bytes(directories_size.to_u32, IO::ByteFormat::LittleEndian)
      io.write_bytes(directory_pointer.to_u32, IO::ByteFormat::LittleEndian)
    end

    private def _write_directory(io : IO, directory : ::WAD::Directory)
      io.write_bytes(directory.file_pos.to_u32, IO::ByteFormat::LittleEndian)
      io.write_bytes(directory.size.to_u32, IO::ByteFormat::LittleEndian)
      name_slice = Bytes.new(8)
      name_slice.copy_from(::WAD.string_sub_chars(::WAD.string_cut(directory.name)).to_slice)
      io.write(name_slice)
    end
  end
end

class WAD
  include WritingAdditions::WAD
end

class WAD::Demo
  include WritingAdditions::Demo
end

class WAD::Map
  include WritingAdditions::Map
end

class WAD::Map::Reject
  include WritingAdditions::Map::Reject
end

class WAD::Map::Blockmap
  include WritingAdditions::Map::Blockmap
end

class WAD::Music
  include WritingAdditions::Music
end

class WAD::Genmidi
  include WritingAdditions::Genmidi
end

class WAD::Dmxgus
  include WritingAdditions::Dmxgus
end

class WAD::PcSound
  include WritingAdditions::PcSound
end

class WAD::Sound
  include WritingAdditions::Sound
end

class WAD::Playpal
  include WritingAdditions::Playpal
end

class WAD::Colormap
  include WritingAdditions::Colormap
end

class WAD::EnDoom
  include WritingAdditions::EnDoom
end

class WAD::TextureX
  include WritingAdditions::TextureX
end

class WAD::Pnames
  include WritingAdditions::Pnames
end

class WAD::Graphic
  include WritingAdditions::Graphic
end

class WAD::Flat
  include WritingAdditions::Flat
end
