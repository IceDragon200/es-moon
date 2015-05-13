module UI
  class TextList < Moon::RenderContext
    attr_reader :index

    def initialize
      super
      create_fonts
      @index = 0
      make_list
    end

    def get_item(index)
      @list[index]
    end

    def current_item
      get_item(@index)
    end

    def find_item(query)
      @list.find do |d|
        d.has?(query)
      end
    end

    def jump_to_item(query)
      @index = @list.index(find_item(query)) || @index
    end

    def create_fonts
      font = FontCache.font 'uni0553', 16
      @text_unselected = Moon::Text.new '', font
      @text_selected = Moon::Text.new '', font
      @text_selected.color = Moon::Vector4.new(0.2000, 0.7098, 0.8980, 1.0000)
      @outline_color = Moon::Vector4.new(0.2000, 0.2000, 0.2000, 1.0000)
    end

    def add_entry(id, name)
      @list.push(id: id, name: name)
    end

    def make_list
      @list = []
    end

    def index=(new_index)
      @index = new_index % [@list.size, 1].max
    end

    def render_content(x, y, z, options)
      oy = 0
      opts = { outline: 2, outline_color: @outline_color }
      @list.each_with_index do |dat, i|
        text = i == @index ? @text_selected : @text_unselected
        text.string = dat[:name]
        text.render(x, y + oy, z, opts)
        oy += text.h
      end
      super
    end
  end
end
