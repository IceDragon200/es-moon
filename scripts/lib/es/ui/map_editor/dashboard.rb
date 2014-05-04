module ES
  module UI

    class MapEditorDashboard < RenderLayer

      attr_accessor :unselected_color
      attr_accessor :selected_color

      def initialize
        super
        @unselected_color = Color.new 1.0, 1.0, 1.0, 1.0
        @selected_color = Color.new 0.3137, 0.7843, 0.4706, 1.0000

        @help       = add_button "book"                                   # F1
        @new_map    = add_button "square-o"                               # F2
        @new_chunk  = add_button "plus-square"                            # F3
        @reserved1  = add_button ""                                       # F4
        @reserved2  = add_button ""                                       # F5
        @reserved3  = add_button ""                                       # F6
        @reserved4  = add_button ""                                       # F7
        @reserved5  = add_button ""                                       # F8
        @reserved6  = add_button ""                                       # F9
        @show_chunk = add_button "search"                                 # F10
        @reserved8  = add_button ""                                       # F11
        @reserved9  = add_button ""                                       # F12

        disable
      end

      def add_button(icon_name)
        button = AwesomeButton.new
        button.text.string = ES::FontStringMap::Awesome[icon_name]
        button.position.set @elements.size * button.width, 0, 0
        add button
        button
      end

      def enable(index=nil)
        if index
          #@elements[index].text.color.set @selected_color
          @elements[index].transition "text.color", @selected_color
        else
          @elements.each { |e| e.text.color.set @selected_color }
        end
      end

      def disable(index=nil)
        if index
          #@elements[index].text.color.set @unselected_color
          @elements[index].transition "text.color", @unselected_color
        else
          @elements.each { |e| e.text.color.set @unselected_color }
        end
      end

    end
  end
end