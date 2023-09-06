class WAD
  # Map containing all directories of data lumps.
  class Map
    # A list of things that the map contains
    MAP_CONTENTS = ["THINGS", "LINEDEFS", "SIDEDEFS", "VERTEXES", "SEGS", "SSECTORS", "NODES", "SECTORS", "REJECT", "BLOCKMAP", "BEHAVIOR"]

    # The name of the map.
    property name : String = ""
    # The directory of the things lump
    property things_directory : Directory = Directory.new
    # The directory of the linedefs lump
    property linedefs_directory : Directory = Directory.new
    # The directory of the sidedefs lump
    property sidedefs_directory : Directory = Directory.new
    # The directory of the vertexes lump
    property vertexes_directory : Directory = Directory.new
    # The directory of the segs lump
    property segs_directory : Directory = Directory.new
    # The directory of the ssectors lump
    property ssectors_directory : Directory = Directory.new
    # The directory of the nodes lump
    property nodes_directory : Directory = Directory.new
    # The directory of the sectors lump
    property sectors_directory : Directory = Directory.new
    # The directory of the reject lump
    property reject_directory : Directory = Directory.new
    # The directory of the blockmap lump
    property blockmap_directory : Directory = Directory.new

    # The parsed things lump
    property things : Array(Thing) = [] of Thing
    # The parsed linedefs lump
    property linedefs : Array(Linedef) = [] of Linedef
    # The parsed sidedefs lump
    property sidedefs : Array(Sidedef) = [] of Sidedef
    # The parsed vertexes lump
    property vertexes : Array(Vertex) = [] of Vertex
    # The parsed segs lump
    property segs : Array(Seg) = [] of Seg
    # The parsed ssectors lump
    property ssectors : Array(Ssector) = [] of Ssector
    # The parsed nodes lump
    property nodes : Array(Node) = [] of Node
    # The parsed sectors lump
    property sectors : Array(Sector) = [] of Sector
    # The parsed reject lump
    property reject : Reject = Reject.new
    # The parsed blockmap lump
    property blockmap : Blockmap = Blockmap.new

    def initialize(@name : String = "")
    end

    # Structure of a thing.
    struct Thing
      property x_position : Int16 = 0_i16
      property y_position : Int16 = 0_i16
      property angle_facing : Int16 = 0_i16
      property thing_type : Int16 = 0_i16
      property flags : Int16 = 0_i16

      # Parses a things list given the filename
      #
      # Opens a things lump and parses it:
      # ```
      # my_things = WAD::Map::Thing.parse("Path/To/Thing")
      # ```
      def self.parse(filename : String | Path) : Array(Thing)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Thing invalid"
      end

      # Parses a things list given the io and the size
      #
      # Opens a things lump and parses it:
      # ```
      # File.open("Path/To/Thing") do |file|
      #   my_things = WAD::Map::Thing.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Thing)
        # Creates a list for all things that will be parsed from the lump.
        parsed_things = [] of Thing
        # Sets the index to loop through.
        things_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 10
        # Loops while the length of the current index is smaller than the lump size.
        while things_index*entry_length < lump_size
          # Creates a new thing.
          thing = Thing.new
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
    end

    # Structure of a linedef.
    struct Linedef
      property start_vertex : Int16 = 0_i16
      property end_vertex : Int16 = 0_i16
      property flags : Int16 = 0_i16
      property special_type : Int16 = 0_i16
      property sector_tag : Int16 = 0_i16
      property front_sidedef : Int16 = 0_i16
      property back_sidedef : Int16 = 0_i16

      # Parses a linedefs list given the filename
      #
      # Opens a linedefs lump and parses it:
      # ```
      # my_linedefs = WAD::Map::Linedef.parse("Path/To/Linedef")
      # ```
      def self.parse(filename : String | Path) : Array(Linedef)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Linedef invalid"
      end

      # Parses a linedefs list given the io and the size
      #
      # Opens a linedefs lump and parses it:
      # ```
      # File.open("Path/To/Linedef") do |file|
      #   my_linedefs = WAD::Map::Linedef.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Linedef)
        # Creates a list for all linedefs that will be parsed from the lump.
        parsed_linedefs = [] of Linedef
        # Sets the index to loop through.
        linedefs_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 14
        # Loops while the length of the current index is smaller than the lump size.
        while linedefs_index*entry_length < lump_size
          # Creates a new linedef.
          linedef = Linedef.new
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
    end

    # Structure of a sidedef.
    struct Sidedef
      property x_offset : Int16 = 0_i16
      property y_offset : Int16 = 0_i16
      property name_tex_up : String = ""
      property name_tex_low : String = ""
      property name_tex_mid : String = ""
      # Sector number this sidedef 'faces'.
      property facing_sector_num : Int16 = 0_i16

      # Parses a sidedefs list given the filename
      #
      # Opens a sidedefs lump and parses it:
      # ```
      # my_sidedefs = WAD::Map::Sidedef.parse("Path/To/Sidedef")
      # ```
      def self.parse(filename : String | Path) : Array(Sidedef)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Sidedef invalid"
      end

      # Parses a sidedefs list given the io and the size
      #
      # Opens a sidedefs lump and parses it:
      # ```
      # File.open("Path/To/Sidedef") do |file|
      #   my_sidedefs = WAD::Map::Sidedef.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Sidedef)
        # Creates a list for all sidedefs that will be parsed from the lump.
        parsed_sidedefs = [] of Sidedef
        # Sets the index to loop through.
        sidedefs_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 30
        # Loops while the length of the current index is smaller than the lump size.
        while sidedefs_index*entry_length < lump_size
          # Creates a new sidedef.
          sidedef = Sidedef.new
          # Reads the data.
          sidedef.x_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          sidedef.y_offset = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          sidedef.name_tex_up = io.gets(8).to_s
          sidedef.name_tex_low = io.gets(8).to_s
          sidedef.name_tex_mid = io.gets(8).to_s
          sidedef.facing_sector_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          # Iterates the index.
          sidedefs_index += 1
          # Pushes sidedef onto list of sidedefs.
          parsed_sidedefs << sidedef
        end
        # Returns the parsed lump.
        parsed_sidedefs
      end
    end

    # Structure of a vertex.
    struct Vertex
      property x_position : Int16 = 0_i16
      property y_position : Int16 = 0_i16

      # Parses a vertexes list given the filename
      #
      # Opens a vertexes lump and parses it:
      # ```
      # my_vertexes = WAD::Map::Vertex.parse("Path/To/Vertex")
      # ```
      def self.parse(filename : String | Path) : Array(Vertex)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Vertex invalid"
      end

      # Parses a vertexes list given the io and the size
      #
      # Opens a vertexes lump and parses it:
      # ```
      # File.open("Path/To/Vertex") do |file|
      #   my_vertexes = WAD::Map::Vertex.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Vertex)
        # Creates a list for all vertexes that will be parsed from the lump.
        parsed_vertexes = [] of Vertex
        # Sets the index to loop through.
        vertexes_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 4
        # Loops while the length of the current index is smaller than the lump size.
        while vertexes_index*entry_length < lump_size
          # Creates a new vertex.
          vertex = Vertex.new
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
    end

    # Structure of a seg.
    struct Seg
      property start_vertex_num : Int16 = 0_i16
      property end_vertex_num : Int16 = 0_i16
      # Angle, full circle is -32768 to 32767.
      property angle : Int16 = 0_i16
      property linedef_num : Int16 = 0_i16
      # Direction, 0 (same as linedef) or 1 (opposite of linedef).
      property direction : Int16 = 0_i16
      # Offset, distance along linedef to start of seg.
      property offset : Int16 = 0_i16

      # Parses a segs list given the filename
      #
      # Opens a segs lump and parses it:
      # ```
      # my_segs = WAD::Map::Seg.parse("Path/To/Seg")
      # ```
      def self.parse(filename : String | Path) : Array(Seg)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Seg invalid"
      end

      # Parses a segs list given the io and the size
      #
      # Opens a segs lump and parses it:
      # ```
      # File.open("Path/To/Seg") do |file|
      #   my_segs = WAD::Map::Seg.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Seg)
        # Creates a list for all segs that will be parsed from the lump.
        parsed_segs = [] of Seg
        # Sets the index to loop through.
        segs_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 12
        # Loops while the length of the current index is smaller than the lump size.
        while segs_index*entry_length < lump_size
          # Creates a new seg.
          seg = Seg.new
          # Reads the data.
          seg.start_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          seg.end_vertex_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          seg.angle = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

          seg.linedef_num = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

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
    end

    # Structure of a ssector.
    struct Ssector
      property seg_count : Int16 = 0_i16
      property first_seg_num : Int16 = 0_i16

      # Parses a ssectors list given the filename
      #
      # Opens a ssectors lump and parses it:
      # ```
      # my_ssectors = WAD::Map::Ssector.parse("Path/To/Ssector")
      # ```
      def self.parse(filename : String | Path) : Array(Ssector)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Ssector invalid"
      end

      # Parses a ssectors list given the io and the size
      #
      # Opens a ssectors lump and parses it:
      # ```
      # File.open("Path/To/Ssector") do |file|
      #   my_ssectors = WAD::Map::Ssector.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Ssector)
        # Creates a list for all ssectors that will be parsed from the lump.
        parsed_ssectors = [] of Ssector
        # Sets the index to loop through.
        ssectors_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 4
        # Loops while the length of the current index is smaller than the lump size.
        while ssectors_index*entry_length < lump_size
          # Creates a new ssector.
          ssector = Ssector.new
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
    end

    # Structure of a node.
    struct Node
      # X coordinate of partition line start.
      property x_coord : Int16 = 0_i16
      # Y coordinate of partition line start.
      property y_coord : Int16 = 0_i16
      # Change in x from start to end of partition line.
      property x_change_to_end : Int16 = 0_i16
      # Change in y from start to end of partition line.
      property y_change_to_end : Int16 = 0_i16

      # Each of the two bounding boxes describe a rectangle which is
      # the area covered by each of the two child nodes respectively.

      # A bounding box consists of four short values (top, bottom, left and right)
      # giving the upper and lower bounds of the y coordinate and the lower and upper
      # bounds of the x coordinate (in that order).
      property right_bound_box : Array(Int16) = [] of Int16
      # :ditto:
      property left_bound_box : Array(Int16) = [] of Int16

      property right_child : Int16 = 0_i16
      property left_child : Int16 = 0_i16

      # Parses a nodes list given the filename
      #
      # Opens a nodes lump and parses it:
      # ```
      # my_nodes = WAD::Map::Node.parse("Path/To/Node")
      # ```
      def self.parse(filename : String | Path) : Array(Node)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Node invalid"
      end

      # Parses a nodes list given the io and the size
      #
      # Opens a nodes lump and parses it:
      # ```
      # File.open("Path/To/Node") do |file|
      #   my_nodes = WAD::Map::Node.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Node)
        # Creates a list for all nodes that will be parsed from the lump.
        parsed_nodes = [] of Node
        # Sets the index to loop trough.
        nodes_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 28
        # Loops while the length of the current index is smaller than the lump size.
        while nodes_index*entry_length < lump_size
          # Creates a new node.
          node = Node.new
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
    end

    # Structure of a sector.
    struct Sector
      property floor_height : Int16 = 0_i16
      property ceiling_height : Int16 = 0_i16
      property name_tex_floor : String = ""
      property name_tex_ceiling : String = ""
      property light_level : Int16 = 0_i16
      property special_type : Int16 = 0_i16
      property tag_num : Int16 = 0_i16

      # Parses a sectors list given the filename
      #
      # Opens a sectors lump and parses it:
      # ```
      # my_sectors = WAD::Map::Sector.parse("Path/To/Sector")
      # ```
      def self.parse(filename : String | Path) : Array(Sector)
        File.open(filename) do |file|
          return self.parse(file, file.size)
        end

        raise "Sector invalid"
      end

      # Parses a sectors list given the io and the size
      #
      # Opens a sectors lump and parses it:
      # ```
      # File.open("Path/To/Sector") do |file|
      #   my_sectors = WAD::Map::Sector.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Array(Sector)
        # Creates a list for all sectors that will be parsed from the lump.
        parsed_sectors = [] of Sector
        # Sets the index to loop through.
        sectors_index = 0
        # Sets the length in bytes that each entry is.
        entry_length = 26
        # Loops while the length of the current index is smaller than the lump size.
        while sectors_index*entry_length < lump_size
          # Create a new sector.
          sector = Sector.new
          # Reads the data.
          sector.floor_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          sector.ceiling_height = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
          sector.name_tex_floor = io.gets(8).to_s
          sector.name_tex_ceiling = io.gets(8).to_s
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
    end

    # Class of a reject.
    class Reject
      property data : BitArray = BitArray.new(0)
      property byte_data : Array(UInt8) = [] of UInt8
      @sectors : Int32 = 0

      # Outputs the truthiness of the bit at the given *x, y*.
      def [](x : Int, y : Int)
        data[x + y * @sectors]
      end

      def initialize(@data : BitArray = BitArray.new(0))
        @sectors = Math.sqrt(data.size).to_i32
      end

      # Parses a reject list given the io and the size
      #
      # Example: Opens a reject lump and parses it
      # ```
      # File.open("Path/To/Reject") do |file|
      #   my_reject = WAD::Map::Reject.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int, sectors : Int = 0) : Reject
        reject = Reject.new
        # DEPRECATED: Use lump_size instead.
        reject_size = (sectors**2)/8
        # Sets the index to loop through.
        reject_index = 0
        # The current bit in to read in a byte.
        sector_byte_loop = 0
        # Creates a slice with size *lump_size*.
        byte_slice = Bytes.new(lump_size)
        # Reads the *io* into *byte_slice*.
        io.read_fully(byte_slice)
        # Converts *byte_slice* into an array.
        byte_slice_array = byte_slice.to_a
        reject.byte_data = byte_slice.to_a
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
        reject.data = bit_array
        reject
      end
    end

    # Class of a blockmap.
    class Blockmap
      # Structure of the blockmap header.
      struct Header
        property grid_origin_x : Int16 = 0_i16
        property grid_origin_y : Int16 = 0_i16
        property num_of_columns : UInt16 = 0_u16
        property num_of_rows : UInt16 = 0_u16
      end

      # Class of the blockmap blocklist
      class Blocklist
        property linedefs_in_block : Array(UInt16) = [] of UInt16
      end

      # There are N blocks, which is equal to columns × rows (from the header).
      def num_of_blocks
        header.num_of_columns * header.num_of_rows
      end

      property header : Header = Header.new
      property offsets : Array(UInt16) = [] of UInt16
      property blocklists : Array(Blocklist) = [] of Blocklist

      # Parses a blockmap list given the io and the size
      #
      # Opens a blockmap lump and parses it:
      # ```
      # File.open("Path/To/Blockmap") do |file|
      #   my_blockmap = WAD::Map::Blockmap.parse(file, file.size)
      # end
      # ```
      def self.parse(io : IO, lump_size : Int) : Blockmap
        # Creates a new blockmap.
        parsed_blockmap = Blockmap.new
        # Reads the header.
        parsed_blockmap.header.grid_origin_x = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        parsed_blockmap.header.grid_origin_y = io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        parsed_blockmap.header.num_of_columns = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        parsed_blockmap.header.num_of_rows = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
        # Finds the remaining size of the *io*.
        blockmap_length = lump_size - (2*4)
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
    end

    # Checks to see if *name* is a map with the name format 'ExMx' or 'MAPxx'.
    #
    # Returns true if the name is a map:
    # ```
    # map_name = "E1M1"
    # if WAD::Map.is_map?(map_name)
    #   puts "Is a Map"
    # else
    #   puts "Is not a Map"
    # end
    # ```
    def self.is_map?(name : String)
      name =~ /^E\dM\d/ || name =~ /^MAP\d\d/
    end

    # Inserts a directory based off of the property:
    # ```
    # map_name = "E1M1"
    # if WAD::Map.is_map?(map_name)
    #   puts "Is a Map"
    # else
    #   puts "Is not a Map"
    # end
    # ```
    def insert_next_property(prop : Directory)
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
