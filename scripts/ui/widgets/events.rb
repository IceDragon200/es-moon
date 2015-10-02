module UI
  module Widgets
    class RadioEvent < Moon::Event
      include Moon::UiEvent

      def initialize(parent)
        @parent = parent
        @target = parent
        super :radio
      end
    end
  end
end
