module ES
  module UI
    class MapEditorHelpPanel < Lunar::Window
      attr_accessor :controlmap

      def initialize(controlmap)
        @controlmap = controlmap
        super()
      end

      def init_elements
        super
        @background.windowskin = Moon::Spritesheet.new('resources/ui/console_windowskin_dark_16x16.png', 16, 16)

        @text = Moon::Text.new '', FontCache.font('uni0553', 16) #16)
        @text.string = '' +
          "#{human_key(@controlmap["erase_tile"])} to erase current tile\n" +
          "#{human_key(@controlmap["copy_tile"])} to select current tile\n" +
          "#{human_key(@controlmap["place_tile"])} to place tile\n" +
          "#{human_key(@controlmap["show_tile_panel"])} opens Tile Panel\n" +
          "#{human_key(@controlmap["edit_layer_0"])} selects the base layer for editing\n" +
          "#{human_key(@controlmap["edit_layer_1"])} selects the detail layer for editing\n" +
          "#{human_key(@controlmap["deactivate_layer_edit"])} deactivates layer editing\n" +
          "#{human_key(@controlmap["zoom_in"])} increase Zoom Level\n" +
          "#{human_key(@controlmap["zoom_out"])} descrease Zoom Level\n" +
          "#{human_key(@controlmap["zoom_reset"])} reset Zoom Level\n" +
          ''
        add(@text)
      end

      def human_key(*keys)
        keys.flatten.map { |key| Moon::Input.key_to_human_readable(key).first }.join(' or ').dump
      end

      private :human_key
    end
  end
end
