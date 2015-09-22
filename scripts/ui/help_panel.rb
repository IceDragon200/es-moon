require 'lunar_ui/window'

module UI
  class MapEditorHelpPanel < Lunar::Window
    attr_accessor :controlmap

    # @param [Hash] controlmap
    def initialize(controlmap)
      @controlmap = controlmap
      super()
    end

    # @!group margin settings
    # @return [Integer]
    def compute_w
      super + 16
    end

    # @return [Integer]
    def compute_h
      super + 16
    end
    # @!endgroup margin settings

    private def initialize_elements
      super
      @background.windowskin = Moon::Spritesheet.new(Game.instance.textures['ui/windowskin_help_panel'], 16, 16)

      @text = Moon::Label.new '', Game.instance.fonts['system.16']
      @text.string = '' <<
        "#{human_key(@controlmap["erase_tile"])} to erase current tile\n" <<
        "#{human_key(@controlmap["sample_tile"])} to sample current tile\n" <<
        "#{human_key(@controlmap["place_tile"])} to place tile\n" <<
        "#{human_key(@controlmap["toggle_tile_panel"])} opens Tile Panel\n" <<
        "#{human_key(@controlmap["edit_layer_0"])} selects the base layer for editing\n" <<
        "#{human_key(@controlmap["edit_layer_1"])} selects the detail layer for editing\n" <<
        "#{human_key(@controlmap["deactivate_layer_edit"])} deactivates layer editing\n" <<
        "#{human_key(@controlmap["zoom_in"])} increase Zoom Level\n" <<
        "#{human_key(@controlmap["zoom_out"])} descrease Zoom Level\n" <<
        "#{human_key(@controlmap["zoom_reset"])} reset Zoom Level\n" <<
        ''
      @text.position.set(8, 8, 0)
      add(@text)
    end

    def human_key(*keys)
      keys.flatten.map { |key| Moon::Input.key_to_human_readable(key).first }.join(' or ').dump
    end

    private :human_key
  end
end
