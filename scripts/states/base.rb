require "scripts/es/states/base/input_context"

module ES
  module States
    class Base < State

      include TransitionHost

      def update(delta)
        super delta
        update_transitions delta
      end

    end
  end
end
