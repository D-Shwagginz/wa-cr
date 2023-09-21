class WAD
  # A doom demo which saves player input states
  class Demo
    # Defines the #clone method
    def_clone

    # 109 for version 1.9
    property game_version : UInt8 = 0_u8
    # Values 0 through 4 indicate "I'm too young to die" through "Nightmare!", respectively.
    property skill_level : UInt8 = 0_u8
    # Always 1 for Doom 2
    property episode : UInt8 = 0_u8
    # The map
    property map : UInt8 = 0_u8
    # 1 means deathmatch, 2 altdeath, 0 is used for single-player or cooperative multi-player
    property multiplayer_mode : UInt8 = 0_u8
    # non-zero value implies use of -respawn
    property respawn : Bool = false
    # non-zero value implies use of -fast
    property fast : Bool = false
    # non-zero value implies use of -nomonsters
    property nomonsters : Bool = false
    # Which player's point of view to use, zero-indexed (0 means player 1)
    property player_pov : UInt8 = 0_u8
    # Set to 1 if player 1 present
    property player1 : Bool = false
    # Set to 2 if player 1 present
    property player2 : Bool = false
    # Set to 3 if player 1 present
    property player3 : Bool = false
    # Set to 4 if player 1 present
    property player4 : Bool = false
    # A series of player actions for each tic encoded in 4 bytes.
    property input_actions : Array(InputAction) = [] of InputAction

    # Each input action for the demo
    struct InputAction
      # Defines the #clone method
      def_clone

      # Positive values indicate forward movement, negative backward.
      property movement_forward_back : Int8 = 0_i8
      # Positive values indicate rightward movement, negative leftward.
      property strafing : Int8 = 0_i8
      # Positive values are left turns, negative right.
      property turning : Int8 = 0_i8
      # The action byte to show what is being performed on the tic
      property action : UInt8 = 0_u8
      # This byte encodes multiple actions in different bits. Indexing is from the least significant bit
      property expanded_action : Interaction = Interaction.new
    end

    # "This byte encodes multiple actions in different bits"
    struct Interaction
      # Defines the #clone method
      def_clone

      # "If set, the weapon is fired; or in special mode pause is toggled"
      property shoot_pause : Bool = false

      # "Opens a door or flips a switch; or in special mode the game to
      # saved to the slot specified by the next three bits:
      # 1xx0001x is slot 1, 1xx1011x is slot 6".
      property interact_save : Bool = false

      # Save game slot, used if *interact_save* == true and *special_mode* == true.
      # Set to 1 by default, because if it is used, the interact_save bit will equal 1.
      property save_slot : UInt8 = 1_u8

      # "Changes to the weapon slot specified by the next three bits:
      # xx0001xx is slot 1, xx1101xx is slot 7".
      property weapon_switch : Bool = false

      # Set to 1 by default, because if it is used, the weapon_switch bit will equal 1.
      property weapon_slot : UInt8 = 1_u8

      # "Sets special mode, changing the meaning of the first two bits".
      property special_mode : Bool = false
    end

    # Parses an file in a demo format
    #
    # Reads an file and puts out a demo:
    # ```
    # my_demo = WAD::Demo.parse("Path/To/Demo")
    # ```
    def self.parse(filename : String | Path) : Demo
      File.open(filename) do |file|
        return self.parse(file)
      end

      raise "Demo invalid"
    end

    # Parses an io in a demo format
    #
    # Reads an io and puts out a demo:
    # ```
    # File.open("Path/To/Demo") do |file|
    #   my_demo = WAD::Demo.parse(file)
    # end
    # ```
    def self.parse(io : IO) : Demo
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
    #
    # Returns true if an io is a demo:
    # ```
    # File.open("Path/To/Demo") do |file|
    #   if WAD::Demo.is_demo(file)
    #     puts "Is Demo"
    #   else
    #     puts "Is not Demo"
    #   end
    # ```
    def self.is_demo?(io : IO)
      begin
        return 109 == io.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      rescue e : IO::EOFError
        return false
      end
    end
  end
end
