module ES
  module Controller
    class Entity

      attr_accessor :entity
      attr_accessor :active

      #attr_accessor :direction

      def initialize(entity)
        @entity = entity
        @active = true

        device = Moon::Input::Keyboard
        @up     = InputHandle.new device, ES::Config.control(:up)
        @down   = InputHandle.new device, ES::Config.control(:down)
        @left   = InputHandle.new device, ES::Config.control(:left)
        @right  = InputHandle.new device, ES::Config.control(:right)

        #@direction = 0.0
      end

      def update
        #vec2 = Vector2[@up.held? ? 1 : (@down.held? ? -1 : 0),
        #               @left.held? ? -1 : (@right.held? ? 1 : 0)].rotate(@direction)
        #@entity.move(*vec2)
        @entity.move(@left.held? ? -1 : (@right.held? ? 1 : 0),
                     @up.held? ? -1 : (@down.held? ? 1 : 0))
      end

    end
  end
end