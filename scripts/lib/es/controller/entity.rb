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
        @entity.move(@left.held? ? -1 : (@right.held? ? 1 : 0),
                     @up.held? ? -1 : (@down.held? ? 1 : 0))
      end

    end
  end
end