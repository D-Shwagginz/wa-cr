module Apps
  module MapGen
    enum MapParts
      Things
      Linedefs
      Sidedefs
      Vertexes
      Sectors
    end

    enum ThingParts
      XPos
      YPos
      AngleFacing
      Type
      Flags
    end

    enum LinedefParts
      StartVertex
      EndVertex
      Flags
      Type
      Tag
      FrontSidedef
      BackSidedef
    end

    enum SidedefParts
      XOffset
      YOffset
      Upper
      Lower
      Middle
      SecNum
    end

    enum VertexParts
      XPos
      YPos
    end

    enum SectorParts
      FloorHeight
      CeilingHeight
      FloorTex
      CeilingTex
      LightLevel
      Type
      Tag
    end

    class_getter map_parts : Array(MapParts) = [
      MapParts::Things,
      MapParts::Linedefs,
      MapParts::Sidedefs,
      MapParts::Vertexes,
      MapParts::Sectors,
    ]

    class_getter thing_parts : Array(ThingParts) = [
      ThingParts::XPos,
      ThingParts::YPos,
      ThingParts::AngleFacing,
      ThingParts::Type,
      ThingParts::Flags,
    ]

    class_getter linedef_parts : Array(LinedefParts) = [
      LinedefParts::StartVertex,
      LinedefParts::EndVertex,
      LinedefParts::Flags,
      LinedefParts::Type,
      LinedefParts::Tag,
      LinedefParts::FrontSidedef,
      LinedefParts::BackSidedef,
    ]

    class_getter sidedef_parts : Array(SidedefParts) = [
      SidedefParts::XOffset,
      SidedefParts::YOffset,
      SidedefParts::Upper,
      SidedefParts::Lower,
      SidedefParts::Middle,
      SidedefParts::SecNum,
    ]

    class_getter vertex_parts : Array(VertexParts) = [
      VertexParts::XPos,
      VertexParts::YPos,
    ]

    class_getter sector_parts : Array(SectorParts) = [
      SectorParts::FloorHeight,
      SectorParts::CeilingHeight,
      SectorParts::FloorTex,
      SectorParts::CeilingTex,
      SectorParts::LightLevel,
      SectorParts::Type,
      SectorParts::Tag,
    ]

    def self.random_string(prng : Random) : String
      str = String.build(8) do |str|
        8.times do |i|
          chr = prng.rand(0..127).chr
          str << chr
        end
      end
      return str
    end

    def self.run(wad_file : String, seed : UInt64)
      wad = WAD.new(WAD::Type::Patch)
      map = WAD::Map.new("E1M1")
      wad.new_dir(map.name)
      wad.maps[map.name] = map

      prng = Random.new(seed)

      map_parts.shuffle(prng)

      map_parts.each do |map_part|
        prng.rand(UInt16::MAX).times do |i|
          case map_part
          when MapParts::Things
            thing = WAD::Map::Thing.new
            thing_parts.shuffle(prng)
            thing_parts.each do |thing_part|
              case thing_part
              when ThingParts::AngleFacing
                thing.angle_facing = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when ThingParts::Flags
                thing.flags = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when ThingParts::Type
                thing.thing_type = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when ThingParts::XPos
                thing.x_position = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when ThingParts::YPos
                thing.y_position = prng.rand(Int16::MIN..Int16::MAX).to_i16
              end
            end
            map.things << thing
          when MapParts::Linedefs
            linedef = WAD::Map::Linedef.new
            linedef_parts.shuffle(prng)
            linedef_parts.each do |linedef_part|
              case linedef_part
              when LinedefParts::StartVertex
                linedef.start_vertex = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::EndVertex
                linedef.end_vertex = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::Flags
                linedef.flags = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::Type
                linedef.special_type = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::Tag
                linedef.sector_tag = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::FrontSidedef
                linedef.front_sidedef = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when LinedefParts::BackSidedef
                linedef.back_sidedef = prng.rand(Int16::MIN..Int16::MAX).to_i16
              end
            end
            map.linedefs << linedef
          when MapParts::Sidedefs
            sidedef = WAD::Map::Sidedef.new
            sidedef_parts.shuffle(prng)
            sidedef_parts.each do |sidedef_part|
              case sidedef_part
              when SidedefParts::XOffset
                sidedef.x_offset = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SidedefParts::YOffset
                sidedef.y_offset = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SidedefParts::Upper
                sidedef.name_tex_up = random_string(prng)
              when SidedefParts::Lower
                sidedef.name_tex_low = random_string(prng)
              when SidedefParts::Middle
                sidedef.name_tex_mid = random_string(prng)
              when SidedefParts::SecNum
                sidedef.facing_sector_num = prng.rand(Int16::MIN..Int16::MAX).to_i16
              end
            end
            map.sidedefs << sidedef
          when MapParts::Vertexes
            vertex = WAD::Map::Vertex.new
            vertex_parts.shuffle(prng)
            vertex_parts.each do |vertex_part|
              case vertex_part
              when VertexParts::XPos
                vertex.x_position = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when VertexParts::YPos
                vertex.y_position = prng.rand(Int16::MIN..Int16::MAX).to_i16
              end
            end
            map.vertexes << vertex
          when MapParts::Sectors
            sector = WAD::Map::Sector.new
            sector_parts.shuffle(prng)
            sector_parts.each do |sector_part|
              case sector_part
              when SectorParts::FloorHeight
                sector.floor_height = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SectorParts::CeilingHeight
                sector.ceiling_height = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SectorParts::FloorTex
                sector.name_tex_floor = random_string(prng)
              when SectorParts::CeilingTex
                sector.name_tex_ceiling = random_string(prng)
              when SectorParts::LightLevel
                sector.light_level = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SectorParts::Type
                sector.special_type = prng.rand(Int16::MIN..Int16::MAX).to_i16
              when SectorParts::Tag
                sector.tag_num = prng.rand(Int16::MIN..Int16::MAX).to_i16
              end
            end
            map.sectors << sector
          end
        end
      end

      wad.write("./rsrc/#{wad_file}_pre.wad")
      Process.new("#{Dir.current}\\rsrc\\bsp51\\bsp-w32.exe #{Dir.current}\\rsrc\\#{wad_file}_pre.wad -o #{Dir.current}\\rsrc\\#{wad_file}.wad", shell: true)
    end
  end
end
