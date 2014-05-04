module ES
  module UI

    class MapEditorDashboard < RenderLayer

      attr_accessor :unselected_color
      attr_accessor :selected_color

      def initialize
        super
        @unselected_color = Color.new 1.0, 1.0, 1.0, 1.0
        @selected_color = Color.new 0.3137, 0.7843, 0.4706, 1.0000

        @help_button = add_button "book"
        @new_map_button = add_button "plus-circle"
        @new_chunk_button = add_button "plus-square"

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