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
      end

      def update
        if @up.held?
          @character.move_xy(0, -1)
        elsif @down.held?
          @character.move_xy(0, 1)
        end
        if @left.held?
          @character.move_xy(-1, 0)
        elsif @right.held?
          @character.move_xy(1, 0)
        end
      end

    end
  end
end