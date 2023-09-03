require "./write/**"

class WAD
  # Writes a WAD class to an io
  #
  # Example: Writes a wad file to *mynewwad.WAD*
  # ```
  # mywad = WAD.read("./rsrc/DOOM.WAD")
  # File.open("./rsrc/mynewwad.WAD", "w+") do |file|
  #   mywad.write(file)
  # end
  # ```
  def write(io : IO)
    written_directories = [] of Directory
    write_directory_pointer = 0_u32

    _write_header(io)

    directories.each do |directory|
      written_directory = Directory.new
      written_directory.name = directory.name
      written_directory.file_pos = io.pos.to_u32

      if Genmidi.is_genmidi?(directory.name)
        written_directory.size = genmidi.write(io)
        written_directories << written_directory
        next
      end

      if Dmxgus.is_dmxgus?(directory.name)
        written_directory.size = dmxgus.write(io)
        written_directories << written_directory
        next
      end

      if Playpal.is_playpal?(directory.name)
        written_directory.size = playpal.write(io)
        written_directories << written_directory
        next
      end

      if Colormap.is_colormap?(directory.name)
        written_directory.size = colormap.write(io)
        written_directories << written_directory
        next
      end

      if EnDoom.is_endoom?(directory.name)
        written_directory.size = endoom.write(io)
        written_directories << written_directory
        next
      end

      if Pnames.is_pnames?(directory.name)
        written_directory.size = pnames.write(io)
        written_directories << written_directory
        next
      end

      if maps.has_key?(directory.name)
        written_directory.size = 0
        written_directories << written_directory
        maps[directory.name].write(io).each do |lump_dir|
          written_directory = Directory.new
          written_directory.name = lump_dir.name
          written_directory.file_pos = lump_dir.file_pos
          written_directory.size = lump_dir.size
          written_directories << written_directory
        end
        next
      end

      if pcsounds.has_key?(directory.name)
        written_directory.size = pcsounds[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if sounds.has_key?(directory.name)
        written_directory.size = sounds[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if music.has_key?(directory.name)
        written_directory.size = music[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if texmaps.has_key?(directory.name)
        written_directory.size = texmaps[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if graphics.has_key?(directory.name)
        written_directory.size = graphics[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if sprites.has_key?(directory.name)
        written_directory.size = sprites[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if flats.has_key?(directory.name)
        written_directory.size = flats[directory.name].write(io)
        written_directories << written_directory
        next
      end

      if demos.has_key?(directory.name)
        written_directory.size = demos[directory.name].write(io)
        written_directories << written_directory
        next
      end

      written_directory.size = 0
      written_directories << written_directory
    end

    write_directory_pointer = io.pos

    written_directories.each do |written_directory|
      _write_directory(io, written_directory)
    end

    io.pos = 0

    _write_header(io, written_directories.size.to_u32, write_directory_pointer)
  end

  private def _write_header(io : IO, directories_size : Int = 0, directory_pointer : Int = 0)
    case type
    when Type::Internal
      io.print("IWAD")
    when Type::Patch
      io.print("PWAD")
    else
      raise "WAD Type is #{type} not Internal or Patch"
    end
    io.write_bytes(directories_size.to_u32, IO::ByteFormat::LittleEndian)
    io.write_bytes(directory_pointer.to_u32, IO::ByteFormat::LittleEndian)
  end

  private def _write_directory(io : IO, directory : Directory)
    io.write_bytes(directory.file_pos.to_u32, IO::ByteFormat::LittleEndian)
    io.write_bytes(directory.size.to_u32, IO::ByteFormat::LittleEndian)
    name_slice = Bytes.new(8)
    name_slice.copy_from(directory.name.to_slice)
    io.write(name_slice)
  end
end
