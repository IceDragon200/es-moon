require 'render_primitives/render_container'
require 'scripts/ui/icon_button'

module UI
  class MapEditorDashboard < Moon::RenderContainer
    attr_accessor :default_color

    def initialize
      super
      pal = ES.game.data_cache.palette
      @default_color = pal['white']
      @info_color    = pal['system/info']
      @ok_color      = pal['system/ok']
      @warning_color = pal['system/warning']
      @error_color   = pal['system/error']

      @help       = add_button 'F1',  'book-question', 'book-open-text'
      @new_map    = add_button 'F2',  'map--plus'
      @new_chunk  = add_button 'F3',  'zone--plus'
      @edit_map   = add_button 'F4',  'map--pencil'
      @save_map   = add_button 'F5',  'disk-black'
      @load_map   = add_button 'F6',  'folder-open-document'
      @play_map   = add_button 'F7',  'application-run'
      @grid       = add_button 'F8',  'border', 'border-outside'
      @keyboard   = add_button 'F9',  'keyboard-space', 'keyboard-smiley'
      @show_chunk = add_button 'F10', 'ui-tooltip'
      @edit       = add_button 'F11', 'wrench'
      @reserved12 = add_button 'F12', 'blank'

      disable
    end

    def add_button(label, icon_name, icon_name_active = nil)
      button = IconButton.new
      button.icon_sprite = Moon::Sprite.new(ES.game.texture_cache.resource("icons/map_editor/2x/#{icon_name}_2x.png"))
      if icon_name_active
        button.icon_sprite_active = Moon::Sprite.new(ES.game.texture_cache.resource("icons/map_editor/2x/#{icon_name_active}_2x.png"))
      end
      button.label = label
      button.position = Moon::Vector3.new(@elements.size * (button.w + 16), 0, 0)
      add button
      button
    end

    def state(color, index = nil)
      if index
        element = @elements[index]
        return if element.icon_sprite_active
        element.transition(:color, color, 0.4)
      else
        @elements.each { |e| e.color.set color }
      end
    end

    def info(index = nil)
      state @info_color, index
    end

    def ok(index = nil)
      state @ok_color, index
      @elements[index].activate if index
    end

    def error(index = nil)
      state @error_color, index
    end

    def warning(index = nil)
      state @warning_color, index
    end

    def disable(index = nil)
      state @default_color, index
      @elements[index].deactivate if index
    end

    def toggle(index, bool)
      bool ? enable(index) : disable(index)
    end

    alias :enable :ok
  end
end
