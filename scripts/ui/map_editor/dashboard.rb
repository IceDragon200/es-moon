module ES
  module UI
    class MapEditorDashboard < Moon::RenderContainer
      attr_accessor :default_color

      def initialize
        super
        pal = DataCache.palette
        @default_color = pal['white']
        @info_color    = pal['system/info']
        @ok_color      = pal['system/ok']
        @warning_color = pal['system/warning']
        @error_color   = pal['system/error']

        @help       = add_button 'book'                              # F1  # 0
        @new_map    = add_button 'square-o'                          # F2  # 1
        @new_chunk  = add_button 'plus-square'                       # F3  # 2
        @reserved4  = add_button ''                                  # F4  # 3
        @reserved5  = add_button 'download'                          # F5  # 4
        @reserved6  = add_button 'upload'                            # F6  # 5
        @reserved7  = add_button ''                                  # F7  # 6
        @grid       = add_button 'table'                             # F8  # 7
        @keyboard   = add_button 'keyboard-o'                        # F9  # 8
        @show_chunk = add_button 'search'                            # F10 # 9
        @edit       = add_button 'edit'                              # F11 # 11
        @reserved12 = add_button ''                                  # F12 # 10

        disable
      end

      def add_button(icon_name)
        button = AwesomeButton.new
        button.text.string = DataCache.charmap('awesome')[icon_name]
        button.position = Moon::Vector3.new(@elements.size * button.w, 0, 0)
        add button
        button
      end

      def state(color, index = nil)
        if index
          @elements[index].transition('text.color', color, 0.15)
        else
          @elements.each { |e| e.text.color.set color }
        end
      end

      def info(index = nil)
        state @info_color, index
      end

      def ok(index = nil)
        state @ok_color, index
      end

      def error(index = nil)
        state @error_color, index
      end

      def warning(index = nil)
        state @warning_color, index
      end

      def disable(index = nil)
        state @default_color, index
      end

      def toggle(index, bool)
        bool ? enable(index) : disable(index)
      end

      alias :enable :ok
    end
  end
end
