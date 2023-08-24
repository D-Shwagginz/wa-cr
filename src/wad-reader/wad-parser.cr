module Parse
  class Things
    property x_position = 0_i16
    property y_position = 0_i16
    property angle_facing = 0_i16
    property thing_type = 0_i16
    property flags = 0_i16
  end

  class Linedefs
  end

  class Sidedefs
  end

  class Vertexes
  end

  class Segs
  end

  class Ssectors
  end

  class Nodes
  end

  class Sectors
  end

  class Reject
  end

  class Blockmap
  end

  class ParsedWAD

    class ParsedMaps
      property name = ""
      property things = Things.new
      property linedefs = Linedefs.new
      property sidedefs = Sidedefs.new
      property vertexes = Vertexes.new
      property segs = Segs.new
      property ssectors = Ssectors.new
      property nodes = Nodes.new
      property sectors = Sectors.new
      property reject = Reject.new
      property blockmap = Blockmap.new
    end

    parsed_maps = [] of ParsedMaps
  end

  def self.things(wad : WAD, directory : WAD::Directory) : Things
    things = Things.new
    File.open(wad.filename) do |file|
      # file.read_at(directory.file_pos, 0) do |io|
      #   puts io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      # end
    end
    things
  end

  def self.map(wad : WAD, map : WAD::Map) : ParsedMap
  end
end