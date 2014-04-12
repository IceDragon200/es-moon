module ES
  module Controller
    class Entity

      attr_accessor :entity
      attr_accessor :active

      def initialize(entity)
        @entity = entity
        @active = true

        device = Moon::Input::Keyboard
        @up     = InputHandle.new(device, ES::Config.controls[:up])
        @down   = InputHandle.new(device, ES::Config.controls[:down])
        @left   = InputHandle.new(device, ES::Config.controls[:left])
        @right  = InputHandle.new(device, ES::Config.controls[:right])
      end

      def update
        if @up.held?
          @entity.move(0, -1)
        elsif @down.held?
          @entity.move(0, 1)
        end
        if @left.held?
          @entity.move(-1, 0)
        elsif @right.held?
          @entity.move(1, 0)
        end
      end

    end
  end
end