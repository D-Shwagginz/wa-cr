# Intends to overload the WAD class.
class WAD
  # Map containing all directories of data lumps.
  class Map
    MAP_CONTENTS = ["THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", "SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP", "BEHAVIOR"]

    # Parses a lump of things given the directory and io.
    def self.parse_things(io : IO, directory : Directory) : Array(Things)
      # Creates a list for all things that will be parsed from the lump.
      parsed_things = [] of Things
      # Sets the index to loop through.
      things_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 10
      # Loops while the length of the current index is smaller than the directory size.
      while things_index*entry_length < directory.size
        # Creates a new thing.
        thing = Things.new
        # Reads the data.
        thing.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.angle_facing = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.thing_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        thing.flags = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        things_index += 1
        # Pushes thing onto list of things.
        parsed_things << thing
      end
      # Returns the parsed lump.
      parsed_things
    end

    # Parses a lump of linedefs given the directory and io.
    def self.parse_linedefs(io : IO, directory : Directory) : Array(Linedefs)
      # Creates a list for all linedefs that will be parsed from the lump.
      parsed_linedefs = [] of Linedefs
      # Sets the index to loop through.
      linedefs_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 14
      # Loops while the length of the current index is smaller than the directory size.
      while linedefs_index*entry_length < directory.size
        # Creates a new linedef.
        linedef = Linedefs.new
        # Reads the data.
        linedef.start_vertex = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.end_vertex = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.flags = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.special_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.sector_tag = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.front_sidedef = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        linedef.back_sidedef = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        linedefs_index += 1
        # Pushes linedef onto list of linedefs.
        parsed_linedefs << linedef
      end
      # Returns the parsed lump.
      parsed_linedefs
    end

    # Parses a lump of sidedefs given the directory and io.
    def self.parse_sidedefs(io : IO, directory : Directory) : Array(Sidedefs)
      # Creates a list for all sidedefs that will be parsed from the lump.
      parsed_sidedefs = [] of Sidedefs
      # Sets the index to loop through.
      sidedefs_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 30
      # Loops while the length of the current index is smaller than the directory size.
      while sidedefs_index*entry_length < directory.size
        # Creates a new sidedef.
        sidedef = Sidedefs.new
        # Reads the data.
        sidedef.x_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sidedef.y_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sidedef.name_tex_up = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.name_tex_low = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.name_tex_mid = io.gets(8).to_s.gsub("\u0000", "")
        sidedef.facing_sector_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        sidedefs_index += 1
        # Pushes sidedef onto list of sidedefs.
        parsed_sidedefs << sidedef
      end
      # Returns the parsed lump.
      parsed_sidedefs
    end

    # Parses a lump of vertexes given the directory and io.
    def self.parse_vertexes(io : IO, directory : Directory) : Array(Vertexes)
      # Creates a list for all vertexes that will be parsed from the lump.
      parsed_vertexes = [] of Vertexes
      # Sets the index to loop through.
      vertexes_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 4
      # Loops while the length of the current index is smaller than the directory size.
      while vertexes_index*entry_length < directory.size
        # Creates a new vertex.
        vertex = Vertexes.new
        # Reads the data.
        vertex.x_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        vertex.y_position = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        vertexes_index += 1
        # Pushes vertex onto list of vertexes.
        parsed_vertexes << vertex
      end
      # Returns the parsed lump.
      parsed_vertexes
    end

    # Parses a lump of segs given the directory and io.
    def self.parse_segs(io : IO, directory : Directory) : Array(Segs)
      # Creates a list for all segs that will be parsed from the lump.
      parsed_segs = [] of Segs
      # Sets the index to loop through.
      segs_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 12
      # Loops while the length of the current index is smaller than the directory size.
      while segs_index*entry_length < directory.size
        # Creates a new seg.
        seg = Segs.new
        # Reads the data.
        seg.start_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        seg.end_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        seg.angle = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        seg.lindef_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        seg.direction = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        seg.offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        segs_index += 1
        # Pushes seg onto list of segs.
        parsed_segs << seg
      end
      # Returns the parsed lump.
      parsed_segs
    end

    # Parses a lump of ssectors given the directory and io.
    def self.parse_ssectors(io : IO, directory : Directory) : Array(Ssectors)
      # Creates a list for all ssectors that will be parsed from the lump.
      parsed_ssectors = [] of Ssectors
      # Sets the index to loop through.
      ssectors_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 4
      # Loops while the length of the current index is smaller than the directory size.
      while ssectors_index*entry_length < directory.size
        # Creates a new ssector.
        ssector = Ssectors.new
        # Reads the data
        ssector.seg_count = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        ssector.first_seg_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        ssectors_index += 1
        # Pushes ssector onto list of ssectors.
        parsed_ssectors << ssector
      end
      # Returns the parsed lump.
      parsed_ssectors
    end

    # Parses a lump of nodes given the directory and io.
    def self.parse_nodes(io : IO, directory : Directory) : Array(Nodes)
      # Creates a list for all nodes that will be parsed from the lump.
      parsed_nodes = [] of Nodes
      # Sets the index to loop trough.
      nodes_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 28
      # Loops while the length of the current index is smaller than the directory size.
      while nodes_index*entry_length < directory.size
        # Creates a new node.
        node = Nodes.new
        # Reads the data.
        node.x_coord = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.y_coord = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.x_change_to_end = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        node.y_change_to_end = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        # WARNING: Don't use 'X.times do' with read_bytes. Causes compiler bug.

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
        # Iterates the index.
        nodes_index += 1
        # Pushes node onto list of nodes.
        parsed_nodes << node
      end
      # Returns the parsed lump.
      parsed_nodes
    end

    # Parses a lump of sectors given the directory and io.
    def self.parse_sectors(io : IO, directory : Directory) : Array(Sectors)
      # Creates a list for all sectors that will be parsed from the lump.
      parsed_sectors = [] of Sectors
      # Sets the index to loop through.
      sectors_index = 0
      # Sets the length in bytes that each entry is.
      entry_length = 26
      # Loops while the length of the current index is smaller than the directory size.
      while sectors_index*entry_length < directory.size
        # Create a new sector.
        sector = Sectors.new
        # Reads the data.
        sector.floor_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.ceiling_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.name_tex_floor = io.gets(8).to_s.gsub("\u0000", "")
        sector.name_tex_ceiling = io.gets(8).to_s.gsub("\u0000", "")
        sector.light_level = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.special_type = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        sector.tag_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Iterates the index.
        sectors_index += 1
        # Pushes sector onto list of sectors.
        parsed_sectors << sector
      end
      # Returns the parsed lump.
      parsed_sectors
    end

    # Parses a reject lump given the directory, io, and number of sectors.
    def self.parse_reject(io : IO, directory : Directory, sectors : Int32 = 0) : Reject
      # DEPRECATED: Use directory.size instead.
      reject_size = (sectors**2)/8
      # Sets the index to loop through.
      reject_index = 0
      # The current bit in to read in a byte.
      sector_byte_loop = 0
      # Creates a slice with size *directory.size*.
      byte_slice = Bytes.new(directory.size)
      # Reads the *io* into *byte_slice*.
      io.read_fully(byte_slice)
      # Converts *byte_slice* into an array.
      byte_slice_array = byte_slice.to_a
      # Creates a bit array with size sectors squared.
      bit_array = BitArray.new(sectors**2)
      # Does the 'y'.
      sectors.times do |y|
        # Does the 'x'.
        sectors.times do |x|
          # Sets an element in *bit_array* to be a bit from the current read byte.
          bit_array[x + y * sectors] = byte_slice_array[0].bit(sector_byte_loop) == 1
          # Checks if the current byte loop is 7, signifying the end of the byte in bits.
          if sector_byte_loop == 7
            # Sets the current bit in a byte to be 0.
            sector_byte_loop = 0
            # Deletes the fully translated byte from the array of bytes.
            byte_slice_array.delete_at(0)
          else
            # Iterates the bit to read.
            sector_byte_loop += 1
          end
        end
        # Iterates the index.
        reject_index += 1
      end
      # Returns reject.
      Reject.new(bit_array)
    end

    # Parses a blockmap lump given the directory and io.
    def self.parse_blockmap(io : IO, directory : Directory) : Blockmap
      # Creates a new blockmap.
      parsed_blockmap = Blockmap.new
      # Reads the header.
      parsed_blockmap.header.grid_origin_x = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.grid_origin_y = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.num_of_columns = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      parsed_blockmap.header.num_of_rows = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      # Finds the remaining size of the *io*.
      blockmap_length = directory.size - (2*4)
      # Loops through the number of block in the map to find the offsets.
      parsed_blockmap.num_of_blocks.times do |time|
        # Reads each offset.
        parsed_blockmap.offsets << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # Removes those bytes from the remaining size of the *io*.
        blockmap_length -= 2
      end
      # Creates a new blocklist.
      blocklist = Blockmap::Blocklist.new
      # Reads each block in the blocklist.
      loop do
        # Breaks if the *io* length is less than 2.
        break if blockmap_length < 2
        # Reads 2 bytes.
        read_byte = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        # Removes those bytes from the remaining size of the *io*.
        blockmap_length -= 2
        # Checks if the byte is not 'FFFF' which shows end of linedefs in blocklist.
        if read_byte != 65535
          # Pushes the read bytes onto the list of linedefs in the blocklist.
          blocklist.linedefs_in_block << read_byte
        else
          # Pushes the blocklist onto the list of blocklists in the blockmap.
          parsed_blockmap.blocklists << blocklist
          # Creates a new blocklist.
          blocklist = Blockmap::Blocklist.new
        end
      end
      # Returns the parsed lump.
      parsed_blockmap
    end

    # Structure of a thing.
    struct Things
      property x_position = 0_i16
      property y_position = 0_i16
      property angle_facing = 0_i16
      property thing_type = 0_i16
      property flags = 0_i16
    end

    # Structure of a linedef.
    struct Linedefs
      property start_vertex = 0_i16
      property end_vertex = 0_i16
      property flags = 0_i16
      property special_type = 0_i16
      property sector_tag = 0_i16
      property front_sidedef = 0_i16
      property back_sidedef = 0_i16
    end

    # Structure of a sidedef.
    struct Sidedefs
      property x_offset = 0_i16
      property y_offset = 0_i16
      property name_tex_up = ""
      property name_tex_low = ""
      property name_tex_mid = ""
      # Sector number this sidedef 'faces'.
      property facing_sector_num = 0_i16
    end

    # Structure of a vertex.
    struct Vertexes
      property x_position = 0_i16
      property y_position = 0_i16
    end

    # Structure of a seg.
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

    # Structure of a ssector.
    struct Ssectors
      property seg_count = 0_i16
      property first_seg_num = 0_i16
    end

    # Structure of a node.
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

    # Structure of a sector.
    struct Sectors
      property floor_height = 0_i16
      property ceiling_height = 0_i16
      property name_tex_floor = ""
      property name_tex_ceiling = ""
      property light_level = 0_i16
      property special_type = 0_i16
      property tag_num = 0_i16
    end

    # Class of a reject.
    class Reject
      property data : BitArray = BitArray.new(0)
      @sectors = 0

      # Outputs the truthiness of the bit at the given *x, y*.
      def [](x, y)
        data[x + y * @sectors]
      end

      def initialize(@data = BitArray.new(0))
        @sectors = Math.sqrt(data.size).to_i32
      end
    end

    # Class of a blockmap.
    class Blockmap
      # Structure of the blockmap header.
      struct Header
        property grid_origin_x = 0_i16
        property grid_origin_y = 0_i16
        property num_of_columns = 0_u16
        property num_of_rows = 0_u16
      end

      # Class of the blockmap blocklist
      class Blocklist
        property linedefs_in_block = [] of UInt16
      end

      # There are N blocks, which is equal to columns × rows (from the header).
      def num_of_blocks
        header.num_of_columns * header.num_of_rows
      end

      property header = Header.new
      property offsets = [] of Int16
      property blocklists = [] of Blocklist
    end

    # Checks to see if *name* is a map with the name format 'ExMx' or 'MAPxx'.
    def self.is_map?(name)
      name =~ /^E\dM\d/ || name =~ /^MAP\d\d/
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

      # The name of the map.
      property name = ""
      # The directories of all map lumps.
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

      # The parsed lumps of the map.
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
    end
  end
end
