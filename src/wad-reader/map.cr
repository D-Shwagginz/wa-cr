# Map containing all directories of data lumps.
class WAD
  class Map
    # Parses a list of things given the directory and io
    def self.parse_things(io : IO, directory : Directory) : Array(Things)
      parsed_things = [] of Things
      things_index = 0
      entry_length = 10
      while things_index*entry_length < directory.size
        thing = Things.new
        thing.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.angle_facing = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.thing_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.flags = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        things_index += 1
        parsed_things << thing
      end
      parsed_things
    end

    # Parses a list of linedefs given the directory and io
    def self.parse_linedefs(io : IO, directory : Directory) : Array(Linedefs)
      parsed_linedefs = [] of Linedefs
      linedefs_index = 0
      entry_length = 14
      while linedefs_index*entry_length < directory.size
        linedef = Linedefs.new
        linedef.start_vertex = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.end_vertex = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.flags = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.special_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.sector_tag = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.front_sidedef = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.back_sidedef = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedefs_index += 1
        parsed_linedefs << linedef
      end
      parsed_linedefs
    end

    # Parses a list of sidedefs given the directory and io
    def self.parse_sidedefs(io : IO, directory : Directory) : Array(Sidedefs)
      parsed_sidedefs = [] of Sidedefs
      sidedefs_index = 0
      entry_length = 30
      while sidedefs_index*entry_length < directory.size
        sidedef = Sidedefs.new
        sidedef.x_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sidedef.y_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sidedef.name_tex_up = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.name_tex_low = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.name_tex_mid = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.facing_sector_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sidedefs_index += 1
        parsed_sidedefs << sidedef
      end
      parsed_sidedefs
    end

    # Parses a list of vertexes given the directory and io
    def self.parse_vertexes(io : IO, directory : Directory) : Array(Vertexes)
      parsed_vertexes = [] of Vertexes
      vertexes_index = 0
      entry_length = 4
      while vertexes_index*entry_length < directory.size
        vertex = Vertexes.new
        vertex.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        vertex.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        vertexes_index += 1
        parsed_vertexes << vertex
      end
      parsed_vertexes
    end

    # Parses a list of segs given the directory and io
    def self.parse_segs(io : IO, directory : Directory) : Array(Segs)
      parsed_segs = [] of Segs
      segs_index = 0
      entry_length = 12
      while segs_index*entry_length < directory.size
        seg = Segs.new
        seg.start_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        seg.end_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        seg.angle = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        seg.lindef_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        seg.direction = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        seg.offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        segs_index += 1
        parsed_segs << seg
      end
      parsed_segs
    end

    # Parses a list of ssectors given the directory and io
    def self.parse_ssectors(io : IO, directory : Directory) : Array(Ssectors)
      parsed_ssectors = [] of Ssectors
      ssectors_index = 0
      entry_length = 4
      while ssectors_index*entry_length < directory.size
        ssector = Ssectors.new
        ssector.seg_count = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        ssector.first_seg_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        ssectors_index += 1
        parsed_ssectors << ssector
      end
      parsed_ssectors
    end

    # Parses a list of nodes given the directory and io
    def self.parse_nodes(io : IO, directory : Directory) : Array(Nodes)
      parsed_nodes = [] of Nodes
      nodes_index = 0
      entry_length = 28
      while nodes_index*entry_length < directory.size
        node = Nodes.new
        node.x_coord = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.y_coord = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.x_change_to_end = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.y_change_to_end = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        # WARNING: Don't use 'X.times do' with read_bytes. Causes compiler bug

        node.right_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.right_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.right_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.right_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        node.left_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.left_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.left_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.left_bound_box << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        node.right_child = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.left_child = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        nodes_index += 1
        parsed_nodes << node
      end
      parsed_nodes
    end

    # Parses a list of sectors given the directory and io
    def self.parse_sectors(io : IO, directory : Directory) : Array(Sectors)
      parsed_sectors = [] of Sectors
      sectors_index = 0
      entry_length = 26
      while sectors_index*entry_length < directory.size
        sector = Sectors.new
        sector.floor_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.ceiling_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.name_tex_floor = io.gets(8).to_s.gsub("\u0000", "")
        sector.name_tex_ceiling = io.gets(8).to_s.gsub("\u0000", "")
        sector.light_level = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.special_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.tag_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sectors_index += 1
        parsed_sectors << sector
      end
      parsed_sectors
    end

    # Parses a reject table given the directory, sectors, and io
    def self.parse_reject(io : IO, directory : Directory, sectors : Int32 = 0) : Reject
      reject_size = (sectors**2)/8
      reject_index = 0
      sector_byte_loop = 0
      current_byte_slice = Bytes.new(directory.size)
      io.read_fully(current_byte_slice)
      current_byte_slice_array = current_byte_slice.to_a
      bit_array = BitArray.new(sectors**2)
      sectors.times do |y|
        sectors.times do |x|
          bit_array[x + y * sectors] = current_byte_slice_array[0].bit(sector_byte_loop) == 1
          if sector_byte_loop == 7
            sector_byte_loop = 0
            current_byte_slice_array.delete_at(0)
          else
            sector_byte_loop += 1
          end
        end
        reject_index += 1
      end
      Reject.new(bit_array)
    end

    # Parses a blockmap given the directory and io
    def self.parse_blockmap(io : IO, directory : Directory) : Blockmap
      parsed_blockmap = Blockmap.new
      blocklist_length = 0

      parsed_blockmap.header.grid_origin_x = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.grid_origin_y = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.num_of_columns = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.num_of_rows = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

      blocklist_length = directory.size - (16*4)

      parsed_blockmap.num_of_blocks.times do |time|
        parsed_blockmap.offsets << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      end

      # blocklist_length -= parsed_blockmap.num_of_blocks

      parsed_blockmap
    end

    struct Things
      property x_position = 0_i16
      property y_position = 0_i16
      property angle_facing = 0_i16
      property thing_type = 0_i16
      property flags = 0_i16
    end

    struct Linedefs
      property start_vertex = 0_i16
      property end_vertex = 0_i16
      property flags = 0_i16
      property special_type = 0_i16
      property sector_tag = 0_i16
      property front_sidedef = 0_i16
      property back_sidedef = 0_i16
    end

    struct Sidedefs
      property x_offset = 0_i16
      property y_offset = 0_i16
      property name_tex_up = ""
      property name_tex_low = ""
      property name_tex_mid = ""
      # Sector number this sidedef 'faces'.
      property facing_sector_num = 0_i16
    end

    struct Vertexes
      property x_position = 0_i16
      property y_position = 0_i16
    end

    struct Segs
      property start_vertex_num = 0_i16
      property end_vertex_num = 0_i16
      # Angle, full circle is -32768 to 32767.
      property angle = 0_i16
      property lindef_num = 0_i16
      # Direction, 0 (same as linedef) or 1 (opposite of linedef).
      property direction = 0_i16
      # Offset, distance along linedef to start of seg.
      property offset = 0_i16
    end

    struct Ssectors
      property seg_count = 0_i16
      property first_seg_num = 0_i16
    end

    struct Nodes
      # X coordinate of partition line start.
      property x_coord = 0_i16
      # Y coordinate of partition line start.
      property y_coord = 0_i16
      # Change in x from start to end of partition line.
      property x_change_to_end = 0_i16
      # Change in y from start to end of partition line.
      property y_change_to_end = 0_i16

      # Each of the two bounding boxes describe a rectangle which is
      # the area covered by each of the two child nodes respectively.

      # A bounding box consists of four short values (top, bottom, left and right)
      # giving the upper and lower bounds of the y coordinate and the lower and upper
      # bounds of the x coordinate (in that order).
      property right_bound_box = [] of Int16
      property left_bound_box = [] of Int16

      property right_child = 0_i16
      property left_child = 0_i16
    end

    struct Sectors
      property floor_height = 0_i16
      property ceiling_height = 0_i16
      property name_tex_floor = ""
      property name_tex_ceiling = ""
      property light_level = 0_i16
      property special_type = 0_i16
      property tag_num = 0_i16
    end

    class Reject
      property data : BitArray = BitArray.new(0)
      @sectors = 0

      # Outputs the truthiness of the bit at the given *x, y*
      def [](x, y)
        data[x + y * @sectors]
      end

      def initialize(@data = BitArray.new(0))
        @sectors = Math.sqrt(data.size).to_i32
      end
    end

    class Blockmap
      struct Header
        property grid_origin_x = 0_i16
        property grid_origin_y = 0_i16
        property num_of_columns = 0_i16
        property num_of_rows = 0_i16
      end

      class Blocklist
        property linedefs_in_block = [] of Int16
      end

      # There are N blocks, which is equal to columns × rows (from the header).
      def num_of_blocks
        header.num_of_columns * header.num_of_rows
      end

      property header = Header.new
      property offsets = [] of Int16
      property blocklists = [] of Blocklist
    end

    property name = ""
    property things_directory : Directory = Directory.new
    property linedefs_directory : Directory = Directory.new
    property sidedefs_directory : Directory = Directory.new
    property vertexes_directory : Directory = Directory.new
    property segs_directory : Directory = Directory.new
    property ssectors_directory : Directory = Directory.new
    property nodes_directory : Directory = Directory.new
    property sectors_directory : Directory = Directory.new
    property reject_directory : Directory = Directory.new
    property blockmap_directory : Directory = Directory.new

    property things = [] of Things
    property linedefs = [] of Linedefs
    property sidedefs = [] of Sidedefs
    property vertexes = [] of Vertexes
    property segs = [] of Segs
    property ssectors = [] of Ssectors
    property nodes = [] of Nodes
    property sectors = [] of Sectors
    property reject : Reject = Reject.new
    property blockmap = Blockmap.new

    def self.is_map?(name)
      name =~ /^E\dM\d/ || name =~ /MAP\d\d/
    end

    # Inserts a property into the map based off *times_inserted*.
    def insert_next_property(prop)
      case prop.name
      when "THINGS"
        @things_directory = prop
      when "LINEDEFS"
        @linedefs_directory = prop
      when "SIDEDEFS"
        @sidedefs_directory = prop
      when "VERTEXES"
        @vertexes_directory = prop
      when "SEGS"
        @segs_directory = prop
      when "SSECTORS"
        @ssectors_directory = prop
      when "NODES"
        @nodes_directory = prop
      when "SECTORS"
        @sectors_directory = prop
      when "REJECT"
        @reject_directory = prop
      when "BLOCKMAP"
        @blockmap_directory = prop
      end
    end
  end
end
