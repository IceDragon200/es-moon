module ES
  module States
    class Shutdown < State

      def init
        super
      end

      def update
        quit
        super
      end

    end
  end
end