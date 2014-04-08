module ES
  module States
    class Shutdown < State

      def init
        super
      end

      def update
        exit
        super
      end

    end
  end
end