require 'scripts/ui/widgets/base'

module UI
  module Widgets
    class RadioGroup < Base
      protected def on_radio_changed(child)
        @active_radio = child
        @elements.each do |elm|
          elm.set_state(child == elm ? 1 : 0)
        end
      end

      protected def initialize_events
        super
        input_bubble.on :radio do |e|
          child = e.parent
          on_radio_changed child
        end
      end
    end
  end
end
