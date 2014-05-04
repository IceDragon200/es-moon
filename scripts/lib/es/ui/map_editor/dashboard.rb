module ES
  module UI

    class MapEditorDashboard < RenderLayer

      attr_accessor :unselected_color
      attr_accessor :selected_color

      def initialize
        super
        @unselected_color = Color.new(1.0, 1.0, 1.0, 1.0)
        @selected_color = Color.new(0.3137, 0.7843, 0.4706, 1.0000)
        @new_chunk_button = AwesomeButton.new
        @new_chunk_button.text.string = ES::FontStringMap::Awesome["plus-square"]
        @new_chunk_button.text.color.set @selected_color
        add @new_chunk_button
      end

      def enable(index)
        @elements[index].text.color.set @selected_color
      end

      def disable(index)
        @elements[index].text.color.set @unselected_color
      end

    end
  end
end