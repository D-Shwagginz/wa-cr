# Intends to overload the WAD class.
class WAD
  # Map containing all directories of data lumps.
  class Map
    def write(io) : Array(Directory)
      written_map_directories = [] of Directory

      written_map_directories << Things.write(io, things)
      written_map_directories << Linedefs.write(io, linedefs)
      written_map_directories << Sidedefs.write(io, sidedefs)
      written_map_directories << Vertexes.write(io, vertexes)
      written_map_directories << Segs.write(io, segs)
      written_map_directories << Ssectors.write(io, ssectors)
      written_map_directories << Nodes.write(io, nodes)
      written_map_directories << Sectors.write(io, sectors)
      written_map_directories << Reject.write(io, reject)
      written_map_directories << Blockmap.write(io, blockmap)

      written_map_directories
    end

    # Structure of a thing.
    struct Things
      def self.write(io, things : Array(Things)) : Directory
        written_directory = Directory.new
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
      def self.write(io, linedefs : Array(Linedefs)) : Directory
        written_directory = Directory.new
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
      def self.write(io, sidedefs : Array(Sidedefs)) : Directory
        written_directory = Directory.new
        written_directory.name = "SIDEDEFS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        sidedefs.each do |sidedef|
          io.write_bytes(sidedef.x_offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sidedef.y_offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32

          string_slice = Bytes.new(8)
          string_slice.copy_from(sidedef.name_tex_up.to_slice)
          io.write(string_slice)
          lump_size += 8_u32

          string_slice = Bytes.new(8)
          string_slice.copy_from(sidedef.name_tex_low.to_slice)
          io.write(string_slice)
          lump_size += 8_u32

          string_slice = Bytes.new(8)
          string_slice.copy_from(sidedef.name_tex_mid.to_slice)
          io.write(string_slice)
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
      def self.write(io, vertexes : Array(Vertexes)) : Directory
        written_directory = Directory.new
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
      def self.write(io, segs : Array(Segs)) : Directory
        written_directory = Directory.new
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
      def self.write(io, ssectors : Array(Ssectors)) : Directory
        written_directory = Directory.new
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
      def self.write(io, nodes : Array(Nodes)) : Directory
        written_directory = Directory.new
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
      def self.write(io, sectors : Array(Sectors)) : Directory
        written_directory = Directory.new
        written_directory.name = "SECTORS"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        sectors.each do |sector|
          io.write_bytes(sector.floor_height.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
          io.write_bytes(sector.ceiling_height.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32

          string_slice = Bytes.new(8)
          string_slice.copy_from(sector.name_tex_floor.to_slice)
          io.write(string_slice)
          lump_size += 8_u32

          string_slice = Bytes.new(8)
          string_slice.copy_from(sector.name_tex_ceiling.to_slice)
          io.write(string_slice)
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
    class Reject
      def self.write(io, reject : Reject) : Directory
        written_directory = Directory.new
        written_directory.name = "REJECT"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        reject.byte_data.each do |byte|
          io.write_bytes(byte, IO::ByteFormat::LittleEndian)
          lump_size += 1_u32
        end

        written_directory.size = lump_size.to_u32
        written_directory
      end
    end

    # Class of a blockmap.
    class Blockmap
      def self.write(io, blockmap : Blockmap) : Directory
        written_directory = Directory.new
        written_directory.name = "BLOCKMAP"
        written_directory.file_pos = io.pos.to_u32

        lump_size = 0_u32

        io.write_bytes(blockmap.header.grid_origin_x.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(blockmap.header.grid_origin_y.to_i16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(blockmap.header.num_of_columns.to_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32
        io.write_bytes(blockmap.header.num_of_rows.to_u16, IO::ByteFormat::LittleEndian)
        lump_size += 2_u32

        blockmap.offsets.each do |offset|
          io.write_bytes(offset.to_i16, IO::ByteFormat::LittleEndian)
          lump_size += 2_u32
        end

        blockmap.blocklists.each do |blocklist|
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
