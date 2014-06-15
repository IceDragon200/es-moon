module ES
  module UI

    class MapEditorDashboard < RenderLayer

      attr_accessor :default_color

      def initialize
        super
        pal = ES.cache.palette
        @default_color = pal["white"]
        @info_color    = pal["system/info"]
        @ok_color      = pal["system/ok"]
        @warning_color = pal["system/warning"]
        @error_color   = pal["system/error"]

        @help       = add_button "book"                                   # F1
        @new_map    = add_button "square-o"                               # F2
        @new_chunk  = add_button "plus-square"                            # F3
        @reserved4  = add_button ""                                       # F4
        @reserved5  = add_button "download"                               # F5
        @reserved6  = add_button "upload"                                 # F6
        @reserved7  = add_button ""                                       # F7
        @reserved8  = add_button ""                                       # F8
        @reserved9  = add_button ""                                       # F9
        @show_chunk = add_button "search"                                 # F10
        @reserved11 = add_button ""                                       # F11
        @reserved12 = add_button ""                                       # F12

        disable
      end

      def add_button(icon_name)
        button = AwesomeButton.new
        button.text.string = ES.cache.charmap("awesome.yml")[icon_name]
        button.position.set @elements.size * button.width, 0, 0
        add button
        button
      end

      def state(color, index=nil)
        if index
          #@elements[index].text.color.set color
          @elements[index].transition "text.color", color
        else
          @elements.each { |e| e.text.color.set color }
        end
      end

      def info(index=nil)
        state @info_color, index
      end

      def ok(index=nil)
        state @ok_color, index
      end

      def error(index=nil)
        state @error_color, index
      end

      def warning(index=nil)
        state @warning_color, index
      end

      def disable(index=nil)
        state @default_color, index
      end

      alias :enable :ok

    end
  end
end
