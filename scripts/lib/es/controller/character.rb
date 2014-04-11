module ES
  module Controller
    class Character

      attr_accessor :character
      attr_accessor :active

      def initialize(character)
        @character = character
        @active = true

        device = Moon::Input::Keyboard
        @up     = InputHandle.new(device, ES::Config.controls[:up])
        @down   = InputHandle.new(device, ES::Config.controls[:down])
        @left   = InputHandle.new(device, ES::Config.controls[:left])
        @right  = InputHandle.new(device, ES::Config.controls[:right])
        @accept = InputHandle.new(device, ES::Config.controls[:accept])
        @cancel = InputHandle.new(device, ES::Config.controls[:cancel])
      end

      def update
        if @up.pressed?
          @character.move(0, -1)
        elsif @down.pressed?
          @character.move(0, 1)
        end
        if @left.pressed?
          @character.move(-1, 0)
        elsif @right.pressed?
          @character.move(1, 0)
        end
      end

    end
  end
end