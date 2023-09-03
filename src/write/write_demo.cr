# Intends to overload the WAD class.
class WAD
  # A doom demo which saves player input states
  class Demo
    # Writes a demo given an output io and returns the size of the written lump
    #
    # Example: Writes a demo in *mywad* to a file
    # ```
    # mywad = WAD.read("./rsrc/DOOM.WAD")
    # File.open("./rsrc/demo.lmp", "w+") do |file|
    #   mywad.demos.values[0].write(file)
    # end
    # ```
    def write(io : IO) : UInt32
      lump_size = 0_u32

      io.write_bytes(game_version.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(skill_level.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(episode.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(map.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(multiplayer_mode.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(respawn.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(fast.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(nomonsters.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(player_pov.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(player1.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(player2.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(player3.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32
      io.write_bytes(player4.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32

      input_actions.each do |input_action|
        io.write_bytes(input_action.movement_forward_back.to_i8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
        io.write_bytes(input_action.strafing.to_i8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
        io.write_bytes(input_action.turning.to_i8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
        io.write_bytes(input_action.action.to_u8, IO::ByteFormat::LittleEndian)
        lump_size += 1_u32
      end

      io.write_bytes(0x80, IO::ByteFormat::LittleEndian)
      lump_size += 1_u32

      lump_size
    end
  end
end
