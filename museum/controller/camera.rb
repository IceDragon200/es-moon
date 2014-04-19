module ES
  module Controller
    class Camera

      attr_accessor :camera
      attr_accessor :active

      def initialize(camera)
        @camera = camera
        @active = true

        device = Moon::Input::Keyboard
        @up     = InputHandle.new device, device::Keys::I
        @down   = InputHandle.new device, device::Keys::K
        @left   = InputHandle.new device, device::Keys::J
        @right  = InputHandle.new device, device::Keys::L
      end

      def update
        if @up.held?
          @camera.position += [ 0, -1]
        elsif @down.held?
          @camera.position += [ 0, 1]
        end
        if @left.held?
          @camera.position += [-1, 0]
        elsif @right.held?
          @camera.position += [1,  0]
        end
      end

    end
  end
end