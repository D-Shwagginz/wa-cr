class WAD
  # A music track.
  class Music
    # Defines the #clone method
    def_clone

    property identifier : String = ""
    property score_len : UInt16 = 0_u16
    property score_start : UInt16 = 0_u16
    # Count of primary channels.
    property channels : UInt16 = 0_u16
    # Count of secondary channels.
    property sec_channels : UInt16 = 0_u16
    property instr_cnt : UInt16 = 0_u16
    property dummy : UInt16 = 0_u16
    property instruments = [] of UInt16

    property song = [] of UInt8

    # The raw .mus file
    property raw = [] of UInt8

    # Parses a music file given the filename
    #
    # Opens a music file and parses it:
    # ```
    # my_music = WAD::Music.parse("Path/To/Music")
    # ```
    def self.parse(filename : String | Path) : Music
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Music invalid"
    end

    # Parses a music file given the io
    #
    # Opens a music io and parses it:
    # ```
    # File.open("Path/To/Music") do |file|
    #   my_music = WAD::Music.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Music
      music = Music.new
      music.raw = io.getb_to_end.to_a
      io.rewind
      # Reads the data.
      music.identifier = io.gets(4).to_s
      music.score_len = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.score_start = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.channels = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.sec_channels = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      music.instr_cnt = io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      # Skips dummy bytes.
      io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      # Reads in the instruments.
      music.instr_cnt.times do
        music.instruments << io.read_bytes(UInt16, IO::ByteFormat::LittleEndian)
      end

      # Reads the rest of the mus file just to have that data
      loop do
        begin
          music.song << io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        rescue e : IO::EOFError
          break
        end
      end

      music
    end

    # Checks to see if *name* is music with name format 'D_x..x'.
    #
    # Returns true if the name is a music:
    # ```
    # music_name = "D_E1M1"
    # if WAD::Music.is_music?(music_name)
    #   puts "Is a Music"
    # else
    #   puts "Is not a Music"
    # end
    # ```
    def self.is_music?(name : String)
      !!(name =~ /^D_/)
    end
  end

  # "Instrument data for the DMX sound library to use for OPL synthesis".
  class Genmidi
    # Defines the #clone method
    def_clone

    property header : String = ""
    property instr_datas : Array(InstrumentData) = [] of InstrumentData
    property instr_names : Array(String) = [] of String

    # "The header is followed by 175 36-byte records of instrument data".
    struct InstrumentData
      # Defines the #clone method
      def_clone

      property header : Array(Int8 | Int16) = [] of Int8 | Int16
      # TODO: Create actual voice data struct
      property voice1_data : Array(Int8 | Int16) = [] of Int8 | Int16
      property voice2_data : Array(Int8 | Int16) = [] of Int8 | Int16
    end

    # Parses a genmidi file given the filename
    #
    # Opens a genmidi file and parses it:
    # ```
    # my_genmidi = WAD::Genmidi.parse("Path/To/Genmidi")
    # ```
    def self.parse(filename : String | Path) : Genmidi
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Genmidi invalid"
    end

    # Parses a genmidi file given the io
    #
    # Opens a genmidi io and parses it:
    # ```
    # File.open("Path/To/Genmidi") do |file|
    #   my_genmidi = WAD::Genmidi.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Genmidi
      genmidi = Genmidi.new
      # Reads the file header
      genmidi.header = io.gets(8).to_s

      instrument_data_records_count = 175

      instrument_data_records_count.times do
        instr_data = InstrumentData.new

        # Reads instrument data's header
        instr_data.header << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        instr_data.header << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        instr_data.header << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        # Reads instrument data's first voice's data
        # First 14 bytes are all 1 byte in size
        14.times do
          instr_data.voice1_data << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        end
        instr_data.voice1_data << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        # reads instrument data's second voice's data
        # First 14 bytes are all 1 byte in size
        14.times do
          instr_data.voice2_data << io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        end
        instr_data.voice2_data << io.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        genmidi.instr_datas << instr_data
      end

      instrument_data_records_count.times do
        genmidi.instr_names << io.gets(32).to_s
      end

      genmidi
    end

    # Checks to see if *name* is "GENMIDI".
    #
    # Returns true if the name is a genmidi:
    # ```
    # genmidi_name = "GENMIDI"
    # if WAD::Genmidi.is_genmidi?(genmidi_name)
    #   puts "Is a Genmidi"
    # else
    #   puts "Is not a Genmidi"
    # end
    # ```
    def self.is_genmidi?(name : String)
      !!(name =~ /^GENMIDI/)
    end
  end

  # "Instrument data for the DMX sound library to use for Gravis Ultrasound soundcards".
  class Dmxgus
    # Defines the #clone method
    def_clone

    property instr_datas : Array(InstrumentData) = [] of InstrumentData

    struct InstrumentData
      # Defines the #clone method
      def_clone

      property patch : Int32 = 0
      # a = 256, b = 512, c = 768, d = 1024
      property a_k : Int32 = 0
      property b_k : Int32 = 0
      property c_k : Int32 = 0
      property d_k : Int32 = 0
      property filename : String = ""
    end

    # Parses a dmxgus file given the filename
    #
    # Opens a dmxgus file and parses it:
    # ```
    # my_dmxgus = WAD::Dmxgus.parse("Path/To/Dmxgus")
    # ```
    def self.parse(filename : String | Path) : Dmxgus
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Dmxgus invalid"
    end

    # Parses a dmxgus file given the io
    #
    # Opens a dmxgus io and parses it:
    # ```
    # File.open("Path/To/Dmxgus") do |file|
    #   my_dmxgus = WAD::Dmxgus.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Dmxgus
      dmxgus = Dmxgus.new
      # Reads each line of the dmxgus
      # NOTE: dmxgus is a text file
      io.gets_to_end.each_line do |line|
        if line.char_at(0) != '#'
          instr_data = InstrumentData.new

          split_line = line.split(',')

          instr_data.patch = split_line[0].to_i
          instr_data.a_k = split_line[1].to_i
          instr_data.b_k = split_line[2].to_i
          instr_data.c_k = split_line[3].to_i
          instr_data.d_k = split_line[4].to_i
          instr_data.filename = split_line[5]

          dmxgus.instr_datas << instr_data
        end
      end

      dmxgus
    end

    # Checks to see if *name* is "DMXGUS"
    #
    # Returns true if the name is a dmxgus:
    # ```
    # dmxgus_name = "DMXGUS"
    # if WAD::Dmxgus.is_dmxgus?(dmxgus_name)
    #   puts "Is a Dmxgus"
    # else
    #   puts "Is not a Dmxgus"
    # end
    # ```
    def self.is_dmxgus?(name : String)
      !!(name =~ /^DMXGUS/) || !!(name =~ /^DMXGUS\d/)
    end
  end
end
