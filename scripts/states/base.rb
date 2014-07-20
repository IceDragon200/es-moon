require "scripts/states/base/input_context"
require "scripts/states/base/state_model"
require "scripts/states/base/state_view"
require "scripts/states/base/state_controller"

module ES
  module States
    class Base < State
      include TransitionHost

      @@__cvar__ = {}

      def update(delta)
        super delta
        update_transitions delta
      end

      def cvar
        @@__cvar__
      end
    end
  end
end
