module WritingAdditions
  # Map containing all directories of data lumps.
  module Map
    # Writes a map given an output io and returns the directories of the written lumps
    #
    # Writes a map in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # my_wad.maps["MyMap"].write("Path/To/map.lmp")
    # ```
    def write(file : String | Path) : Array(::WAD::Directory)
      File.open(file, "w+") do |file|
        return write(file)
      end
    end

    # Writes a map given an output io and returns the directories of the written lumps
    #
    # Writes a map in *my_wad* to a file:
    # ```
    # my_wad = WAD.read("Path/To/Wad")
    # File.open("Path/To/map.lmp", "w+") do |file|
    #   my_wad.maps["MyMap"].write(file)
    # end
    # ```
    def write(io : IO) : Array(::WAD::Directory)
      written_map_directories = [] of ::WAD::Directory

      written_map_directories << Things.write(io, things)
      written_map_directories << Linedefs.write(io, linedefs)
      written_map_directories << Sidedefs.write(io, sidedefs)
      written_map_directories << Vertexes.write(io, vertexes)
      written_map_directories << Segs.write(io, segs)
      written_map_directories << Ssectors.write(io, ssectors)
      written_map_directories << Nodes.write(io, nodes)
      written_map_directories << Sectors.write(io, sectors)
      written_map_directories << reject.write(io)
      written_map_directories << blockmap.write(io)

      written_map_directories
    end

    # Structure of a thing.
    struct Things
      # Writes a list of things given an output io and the things
      # to write and returns the written directory
      #
      # Writes things in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Things.write("Path/To/things.lmp", my_wad.maps["MyMap"].things)
      # ```
      def self.write(file : String | Path, things : Array(::WAD::Map::Things)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, things)
        end
      end

      # Writes a list of things given an output io and the things
      # to write and returns the written directory
      #
      # Writes things in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/things.lmp", "w+") do |file|
      #   WAD::Map::Things.write(my_wad.maps["MyMap"].things)
      # end
      # ```
      def self.write(io : IO, things : Array(::WAD::Map::Things)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "THINGS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        things.each do |thing|
          io.write_bytes(thing.x_position.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(thing.y_position.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(thing.angle_facing.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(thing.thing_type.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(thing.flags.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end
        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a linedef.
    struct Linedefs
      # Writes a list of linedefs given an output io and the linedefs
      # to write and returns the written directory
      #
      # Writes linedefs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Linedefs.write("Path/To/linedefs.lmp", my_wad.maps["MyMap"].linedefs)
      # ```
      def self.write(file : String | Path, linedefs : Array(::WAD::Map::Linedefs)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, linedefs)
        end
      end

      # Writes a list of linedefs given an output io and the linedefs
      # to write and returns the written directory
      #
      # Writes linedefs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/linedefs.lmp", "w+") do |file|
      #   WAD::Map::Linedefs.write(my_wad.maps["MyMap"].linedefs)
      # end
      # ```
      def self.write(io : IO, linedefs : Array(::WAD::Map::Linedefs)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "LINEDEFS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        linedefs.each do |linedef|
          io.write_bytes(linedef.start_vertex.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.end_vertex.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.flags.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.special_type.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.sector_tag.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.front_sidedef.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(linedef.back_sidedef.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end
        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a sidedef.
    struct Sidedefs
      # Writes a list of sidedefs given an output io and the sidedefs
      # to write and returns the written directory
      #
      # Writes sidedefs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Sidedefs.write("Path/To/sidedefs.lmp", my_wad.maps["MyMap"].sidedefs)
      # ```
      def self.write(file : String | Path, sidedefs : Array(::WAD::Map::Sidedefs)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, sidedefs)
        end
      end

      # Writes a list of sidedefs given an output io and the sidedefs
      # to write and returns the written directory
      #
      # Writes sidedefs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/sidedefs.lmp", "w+") do |file|
      #   WAD::Map::Sidedefs.write(my_wad.maps["MyMap"].sidedefs)
      # end
      # ```
      def self.write(io : IO, sidedefs : Array(::WAD::Map::Sidedefs)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "SIDEDEFS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        sidedefs.each do |sidedef|
          io.write_bytes(sidedef.x_offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sidedef.y_offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32

          name_slice = Bytes.new(8)
          name_slice.copy_from(::WAD.slice_cut(::WAD.string_cut(sidedef.name_tex_up).to_slice))
          io.write(name_slice)
          lump_size += 8_u32

          name_slice = Bytes.new(8)
          name_slice.copy_from(::WAD.slice_cut(::WAD.string_cut(sidedef.name_tex_low).to_slice))
          io.write(name_slice)
          lump_size += 8_u32

          name_slice = Bytes.new(8)
          name_slice.copy_from(::WAD.slice_cut(::WAD.string_cut(sidedef.name_tex_mid).to_slice))
          io.write(name_slice)
          lump_size += 8_u32

          io.write_bytes(sidedef.facing_sector_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end
        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a vertex.
    struct Vertexes
      # Writes a list of vertexes given an output io and the vertexes
      # to write and returns the written directory
      #
      # Writes vertexes in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Vertexes.write("Path/To/vertexes.lmp", my_wad.maps["MyMap"].vertexes)
      # ```
      def self.write(file : String | Path, vertexes : Array(::WAD::Map::Vertexes)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, vertexes)
        end
      end

      # Writes a list of vertexes given an output io and the vertexes
      # to write and returns the written directory
      #
      # Writes vertexes in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/vertexes.lmp", "w+") do |file|
      #   WAD::Map::Vertexes.write(my_wad.maps["MyMap"].vertexes)
      # end
      # ```
      def self.write(io : IO, vertexes : Array(::WAD::Map::Vertexes)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "VERTEXES"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        vertexes.each do |vertex|
          io.write_bytes(vertex.x_position.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(vertex.y_position.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end
        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a seg.
    struct Segs
      # Writes a list of segs given an output io and the segs
      # to write and returns the written directory
      #
      # Writes segs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Segs.write("Path/To/segs.lmp", my_wad.maps["MyMap"].segs)
      # ```
      def self.write(file : String | Path, segs : Array(::WAD::Map::Segs)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, segs)
        end
      end

      # Writes a list of segs given an output io and the segs
      # to write and returns the written directory
      #
      # Writes segs in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/segs.lmp", "w+") do |file|
      #   WAD::Map::Segs.write(my_wad.maps["MyMap"].segs)
      # end
      # ```
      def self.write(io : IO, segs : Array(::WAD::Map::Segs)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "SEGS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        segs.each do |seg|
          io.write_bytes(seg.start_vertex_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(seg.end_vertex_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(seg.angle.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(seg.linedef_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(seg.direction.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(seg.offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a ssector.
    struct Ssectors
      # Writes a list of ssectors given an output io and the ssectors
      # to write and returns the written directory
      #
      # Writes ssectors in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Ssectors.write("Path/To/ssectors.lmp", my_wad.maps["MyMap"].ssectors)
      # ```
      def self.write(file : String | Path, ssectors : Array(::WAD::Map::Ssectors)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, ssectors)
        end
      end

      # Writes a list of ssectors given an output io and the ssectors
      # to write and returns the written directory
      #
      # Writes ssectors in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/ssectors.lmp", "w+") do |file|
      #   WAD::Map::Ssectors.write(my_wad.maps["MyMap"].ssectors)
      # end
      # ```
      def self.write(io : IO, ssectors : Array(::WAD::Map::Ssectors)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "SSECTORS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        ssectors.each do |ssector|
          io.write_bytes(ssector.seg_count.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(ssector.first_seg_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a node.
    struct Nodes
      # Writes a list of nodes given an output io and the nodes
      # to write and returns the written directory
      #
      # Writes nodes in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Nodes.write("Path/To/nodes.lmp", my_wad.maps["MyMap"].nodes)
      # ```
      def self.write(file : String | Path, nodes : Array(::WAD::Map::Nodes)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, nodes)
        end
      end

      # Writes a list of nodes given an output io and the nodes
      # to write and returns the written directory
      #
      # Writes nodes in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/nodes.lmp", "w+") do |file|
      #   WAD::Map::Nodes.write(my_wad.maps["MyMap"].nodes)
      # end
      # ```
      def self.write(io : IO, nodes : Array(::WAD::Map::Nodes)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "NODES"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        nodes.each do |node|
          io.write_bytes(node.x_coord.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(node.y_coord.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(node.x_change_to_end.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(node.y_change_to_end.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32

          node.right_bound_box.each do |value|
            io.write_bytes(value.to_i16, IO::ByteFormat::LittleEndian)
            lump_size += 2_u32
          end

          node.left_bound_box.each do |value|
            io.write_bytes(value.to_i16, IO::ByteFormat::LittleEndian)
            lump_size += 2_u32
          end

          io.write_bytes(node.right_child.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(node.left_child.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Structure of a sector.
    struct Sectors
      # Writes a list of sectors given an output io and the sectors
      # to write and returns the written directory
      #
      # Writes sectors in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # WAD::Map::Sectors.write("Path/To/sectors.lmp", my_wad.maps["MyMap"].sectors)
      # ```
      def self.write(file : String | Path, sectors : Array(::WAD::Map::Sectors)) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return self.write(file, sectors)
        end
      end

      # Writes a list of sectors given an output io and the sectors
      # to write and returns the written directory
      #
      # Writes sectors in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/sectors.lmp", "w+") do |file|
      #   WAD::Map::Sectors.write(my_wad.maps["MyMap"].sectors)
      # end
      # ```
      def self.write(io : IO, sectors : Array(::WAD::Map::Sectors)) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "SECTORS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        sectors.each do |sector|
          io.write_bytes(sector.floor_height.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sector.ceiling_height.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32

          name_slice = Bytes.new(8)
          name_slice.copy_from(::WAD.slice_cut(::WAD.string_cut(sector.name_tex_floor).to_slice))
          io.write(name_slice)
          lump_size += 8_u32

          name_slice = Bytes.new(8)
          name_slice.copy_from(::WAD.slice_cut(::WAD.string_cut(sector.name_tex_ceiling).to_slice))
          io.write(name_slice)
          lump_size += 8_u32

          io.write_bytes(sector.light_level.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sector.special_type.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sector.tag_num.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Class of a reject.
    module Reject
      # Writes a reject given an output io and the reject
      # to write and returns the written directory
      #
      # Writes reject in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # my_wad.maps["MyMap"].reject.write("Path/To/reject.lmp")
      # ```
      def write(file : String | Path) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return write(file)
        end
      end

      # Writes a reject given an output io and the reject
      # to write and returns the written directory
      #
      # Writes reject in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/reject.lmp", "w+") do |file|
      #   my_wad.maps["MyMap"].reject.write(file)
      # end
      # ```
      def write(io : IO) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "REJECT"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        byte_data.each do |byte|
          io.write_bytes(byte, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Class of a blockmap.
    module Blockmap
      # Writes a blockmap given an output io and the blockmap
      # to write and returns the written directory
      #
      # Writes blockmap in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # my_wad.maps["MyMap"].blockmap.write("Path/To/blockmap.lmp")
      # ```
      def write(file : String | Path) : ::WAD::Directory
        File.open(file, "w+") do |file|
          return write(file)
        end
      end

      # Writes a blockmap given an output io and the blockmap
      # to write and returns the written directory
      #
      # Writes blockmap in *my_wad* to a file:
      # ```
      # my_wad = WAD.read("Path/To/Wad")
      # File.open("Path/To/blockmap.lmp", "w+") do |file|
      #   my_wad.maps["MyMap"].blockmap.write(file)
      # end
      # ```
      def write(io : IO) : ::WAD::Directory
        written_directory = ::WAD::Directory.new
        written_directory.name = "BLOCKMAP"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        io.write_bytes(header.grid_origin_x.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(header.grid_origin_y.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(header.num_of_columns.to_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(header.num_of_rows.to_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32

        offsets.each do |offset|
          io.write_bytes(offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        blocklists.each do |blocklist|
          io.write_bytes(0_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          blocklist.linedefs_in_block.each do |value|
            io.write_bytes(value.to_u16, IO::ByteFormat::LittleEndian)
            lump_size += 2_u32
          end
        end

        io.write_bytes(65535_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end
  end
end
