require 'scripts/ui/widgets'

module States
  module Test
    class UI < Base
      def start
        super
        @panel = ::UI::Widgets::Panel.new(auto_resize: false, w: 320, h: 320)

        checkbox = ::UI::Widgets::Checkbox.new
        checkbox.position.x = 16
        checkbox.position.y = 16
        @panel.add checkbox

        @radio_group = ::UI::Widgets::RadioGroup.new
        @radio_group.add ::UI::Widgets::RadioButton.new(position: [0, 0, 0])
        @radio_group.add ::UI::Widgets::RadioButton.new(position: [16, 0, 0])
        @radio_group.add ::UI::Widgets::RadioButton.new(position: [32, 0, 0])
        @radio_group.position.x = 16
        @radio_group.position.y = 32
        @panel.add @radio_group

        @button = ::UI::Widgets::Button.new(w: 64, h: 16, auto_resize: false)
        @button.position.set(@panel.x2 - 80, @panel.y2 - 32, 0)
        @panel.add @button

        p [@panel.w, @panel.h]
        @gui.add @panel
      end
    end
  end
end
