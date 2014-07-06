require "scripts/es/states/base/input_context"

module ES
  module States
    class Base < State

      include TaskHost
      include IntervalHost
      include TransitionHost

      def update(delta)
        super delta
        update_tasks delta
        update_intervals delta
        update_transitions delta
      end

    end
  end
end
