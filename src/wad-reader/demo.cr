# Intends to overload the WAD class.
class WAD
  # A doom demo which saves player input states
  class Demo
    property name = ""
    property game_version = 0_u8
    property skill_level = 0_u8
    property episode = 0_u8
    property map = 0_u8
    property multiplayer_mode = 0_u8
    property respawn : Bool = false
    property fast : Bool = false
    property nomonsters : Bool = false
    property player_pov = 0_u8
    property player1 : Bool = false
    property player2 : Bool = false
    property player3 : Bool = false
    property player4 : Bool = false
    property input_actions = [] of InputAction

    # Each input action for the demo
    struct InputAction
      property movement_forward_back = 0_i8
      property strafing = 0_i8
      property turning = 0_i8
      property action = 0_u8
      property expanded_action : Interaction = Interaction.new
    end

    # "This byte encodes multiple actions in different bits"
    struct Interaction
      # "If set, the weapon is fired; or in special mode pause is toggled"
      property shoot_pause : Bool = false

      # "Opens a door or flips a switch; or in special mode the game to
      # saved to the slot specified by the next three bits:
      # 1xx0001x is slot 1, 1xx1011x is slot 6".
      property interact_save : Bool = false

      # Save game slot, used if *interact_save* == true and *special_mode* == true.
      # Set to 1 by default, because if it is used, the interact_save bit will equal 1.
      property save_slot = 1_u8

      # "Changes to the weapon slot specified by the next three bits:
      # xx0001xx is slot 1, xx1101xx is slot 7".
      property weapon_switch : Bool = false

      # Set to 1 by default, because if it is used, the weapon_switch bit will equal 1.
      property weapon_slot = 1_u8

      # "Sets special mode, changing the meaning of the first two bits".
      property special_mode : Bool = false
    end

    def self.parse(io, name)
      demo = Demo.new

      demo.game_version = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.skill_level = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.episode = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.map = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.multiplayer_mode = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.respawn = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) != 0)
      demo.fast = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) != 0)
      demo.nomonsters = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) != 0)
      demo.player_pov = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      demo.player1 = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 1)
      demo.player2 = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 1)
      demo.player3 = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 1)
      demo.player4 = (io.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 1)

      while (start_byte = io.read_bytes(Int8, IO::ByteFormat::LittleEndian)) != -128
        inputaction = InputAction.new

        inputaction.movement_forward_back = start_byte
        inputaction.strafing = io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        inputaction.turning = io.read_bytes(Int8, IO::ByteFormat::LittleEndian)
        inputaction.action = io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

        action_bits = BitArray.new(8)

        8.times do |time|
          action_bits[time] = inputaction.action.bit(7 - time) == 1
        end

        inputaction.expanded_action.special_mode = action_bits[7]

        if inputaction.expanded_action.special_mode
          inputaction.expanded_action.shoot_pause = action_bits[0]
          inputaction.expanded_action.interact_save = action_bits[1]

          if inputaction.expanded_action.interact_save
            inputaction.expanded_action.save_slot += 1 if action_bits[2]
            inputaction.expanded_action.save_slot += 2 if action_bits[3]
            inputaction.expanded_action.save_slot += 4 if action_bits[4]
          end
        else
          inputaction.expanded_action.weapon_switch = action_bits[2]

          if inputaction.expanded_action.weapon_switch
            inputaction.expanded_action.weapon_slot += 1 if action_bits[3]
            inputaction.expanded_action.weapon_slot += 2 if action_bits[4]
            inputaction.expanded_action.weapon_slot += 4 if action_bits[5]
          else
            inputaction.expanded_action.interact_save = action_bits[1]
            inputaction.expanded_action.shoot_pause = action_bits[0]
          end
        end
        demo.input_actions << inputaction
      end
      demo
    end

    # Checks if the demo is of doom version 1,9
    def self.is_demo?(io)
      begin
        return 109 == io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      rescue e : IO::EOFError
        return false
      end
    end
  end
end
