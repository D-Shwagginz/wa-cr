class WAD
  class Directory
    property file_pos = 0_u32
    property size = 0_u32
    property name = ""

    def self.read(io) : Directory
      directory = Directory.new
      directory.file_pos = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.size = io.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      directory.name = io.gets(8).to_s.gsub("\u0000", "")
      directory
    end
  end

  class Map
    property name = ""
    property things = Directory.new
    property linedefs = Directory.new
    property sidedefs = Directory.new
    property vertexes = Directory.new
    property segs = Directory.new
    property ssectors = Directory.new
    property nodes = Directory.new
    property sectors = Directory.new
    property reject = Directory.new
    property blockmap = Directory.new

    @times_inserted = 0
    
    def insert_next_property(prop)
      case @times_inserted
      when 0
        @things = prop
      when 1
        @linedefs = prop
      when 2 
        @sidedefs = prop
      when 3
        @vertexes = prop
      when 4 
        @segs = prop
      when 5 
        @ssectors = prop
      when 6 
        @nodes = prop
      when 7 
        @sectors = prop
      when 8 
        @reject = prop
      when 9 
        @blockmap = prop
      end
      @times_inserted += 1
    end
  end

  def self.read(filename) : WAD
    wad = WAD.new
    wad.filename = filename
    File.open(filename) do |file|
      char = file.read_char
      if char == 'I'
        wad.type = WADType::Internal
      elsif char == 'P'
        wad.type = WADType::Patch
      end
      3.times { file.read_char }

      wad.directories_count = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      d_index = 0
      while d_index < wad.directories_count
        file.read_at(wad.directory_pointer+(d_index*16), 16) do |io|
          d_index += 1
          directory = Directory.read(io)
          wad.directories << directory
          if directory.name =~ /^E\dM\d/ || directory.name =~ /MAP\d\d/
            map = Map.new
            map.name = directory.name
            1.times do 
              file.read_at(wad.directory_pointer+(d_index*16), 16) do |io|
                puts wad.directory_pointer+(d_index*16)
                map.insert_next_property(Directory.read(io))
                d_index += 1
              end
            end
            wad.maps << map
          end
        end
      end

    end
    wad
  end

  enum WADType
    Internal
    Patch
  end

  property type : WADType = WADType::Internal

  def internal?
    type == WADType::Internal
  end

  def patch?
    type == WADType::Patch
  end

  property filename = ""
  property directories_count = 0_u32
  property directory_pointer = 0_u32
  property maps = [] of Map
  property directories = [] of Directory
end
