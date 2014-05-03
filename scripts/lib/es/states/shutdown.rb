module ES
  module States
    class Shutdown < State

      def init
        super
      end

      def update(delta)
        quit
        super delta
      end

    end
  end
end