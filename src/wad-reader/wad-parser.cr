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
      property things = [] of Things
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

  def self.things(wad : WAD, directory : WAD::Directory) : Array(Things)
    parsed_things = [] of Things
    things_index = 0
    File.open(wad.filename) do |file|
      file.read_at(directory.file_pos, directory.size) do |io|
        while things_index*10 < directory.size 
          thing = Things.new
          thing.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          thing.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          thing.angle_facing = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          thing.thing_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          thing.flags = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          things_index += 1
          parsed_things << thing
        end
      end
    end
    parsed_things
  end

  def self.map(wad : WAD, map : WAD::Map) : ParsedMap
  end
end