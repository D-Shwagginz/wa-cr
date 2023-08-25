# Map containing all directories of data lumps.
class WAD
  struct Map
    # Parses a list of things given the directory and wad
    # TODO: PASS IO
    def self.parse_things(io : IO, directory : Directory) : Array(Things)
      parsed_things = [] of Things
      things_index = 0
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
      parsed_things
    end

    # Parses a list of linedefs given the directory and wad
    def self.parse_linedefs(wad : WAD, directory : WAD::Directory) : Array(Linedefs)
      parsed_linedefs = [] of Linedefs
      linedefs_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while linedefs_index*14 < directory.size
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
        end
      end
      parsed_linedefs
    end

    # Parses a list of sidedefs given the directory and wad
    def self.parse_sidedefs(wad : WAD, directory : WAD::Directory) : Array(Sidedefs)
      parsed_sidedefs = [] of Sidedefs
      sidedefs_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while sidedefs_index*30 < directory.size
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
        end
      end
      parsed_sidedefs
    end

    # Parses a list of vertexes given the directory and wad
    def self.parse_vertexes(wad : WAD, directory : WAD::Directory) : Array(Vertexes)
      parsed_vertexes = [] of Vertexes
      vertexes_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while vertexes_index*4 < directory.size
            vertex = Vertexes.new
            vertex.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
            vertex.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
            vertexes_index += 1
            parsed_vertexes << vertex
          end
        end
      end
      parsed_vertexes
    end

    # Parses a list of segs given the directory and wad
    def self.parse_segs(wad : WAD, directory : WAD::Directory) : Array(Segs)
      parsed_segs = [] of Segs
      segs_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while segs_index*12 < directory.size
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
        end
      end
      parsed_segs
    end

    # Parses a list of ssectors given the directory and wad
    def self.parse_ssectors(wad : WAD, directory : WAD::Directory) : Array(Ssectors)
      parsed_ssectors = [] of Ssectors
      ssectors_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while ssectors_index*4 < directory.size
            ssector = Ssectors.new
            ssector.seg_count = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
            ssector.first_seg_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
            ssectors_index += 1
            parsed_ssectors << ssector
          end
        end
      end
      parsed_ssectors
    end

    # Parses a list of nodes given the directory and wad
    def self.parse_nodes(wad : WAD, directory : WAD::Directory) : Array(Nodes)
      parsed_nodes = [] of Nodes
      nodes_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while nodes_index*28 < directory.size
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
        end
      end
      parsed_nodes
    end

    # Parses a list of sectors given the directory and wad
    def self.parse_sectors(wad : WAD, directory : WAD::Directory) : Array(Sectors)
      parsed_sectors = [] of Sectors
      sectors_index = 0
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while sectors_index*26 < directory.size
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
        end
      end
      parsed_sectors
    end

    # Parses a reject table given the directory, wad, and number of sectors
    def self.parse_reject(wad : WAD, directory : WAD::Directory) : Reject
      parsed_reject = Reject.new
      reject_index = 0
      reject_slice = Bytes.new(1)
      bit_array = BitArray.new(8)
      File.open(wad.filename) do |file|
        file.read_at(directory.file_pos, directory.size) do |io|
          while reject_index < directory.size
            bit_array[(reject_index) - (8*(reject_index//8))] = io.read_bytes(Int8, IO::ByteFormat::LittleEndian).bit((reject_index + 1) - (8*(reject_index//8))) == 1
            puts bit_array

            reject_index += 1
            # parsed_reject.reject_table <<
          end
        end
      end
      parsed_reject
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

    struct Reject
      property reject_table : Array(BitArray) = [] of BitArray
    end

    struct Blockmap
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
    property reject = [] of Reject
    property blockmap = [] of Blockmap

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
