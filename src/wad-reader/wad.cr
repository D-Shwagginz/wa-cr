class WAD
  def self.read(filename) : WAD
    wad = WAD.new
    File.open(filename) do |file|
      char = file.read_char
      if char == 'I'
        wad.type = WADType::Internal
      elsif char == 'P'
        wad.type = WADType::Patch
      end
      3.times { file.read_char }

      wad.lumps_count = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
      wad.directory_pointer = file.read_bytes(UInt32, IO::ByteFormat::LittleEndian)
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

  property lumps_count = 0_u32
  property directory_pointer = 0_u32
end