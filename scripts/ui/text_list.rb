module UI
  class TextList < Moon::RenderContainer
    include Moon::Indexable
    include Moon::Activatable

    attr_accessor :active

    attr_reader :font

    # @param [Moon::Font] font
    def font=(font)
      @font = font
      @elements.each do |element|
        element.font = @font
      end
    end

    private def initialize_from_options(options)
      super
      self.font = options.fetch(:font)
    end

    private def initialize_members
      super
      initialize_index
      @active = true
      @list = []
    end

    private def initialize_content
      super
      create_colors
    end

    private def register_input_events
      input.on [:press, :repeat] do |e|
        if active?
          case e.key
          when :up   then self.index -= 1
          when :down then self.index += 1
          end
        end
      end

      input.on :press do |e|
        if active? && (e.key == :enter || e.key == :z)
          (cb = current_item[:cb]) && cb.call
        end
      end
    end

    private def initialize_events
      super
      register_input_events

      on :index do |e|
        col = case e.state
        when :pre_index
          @normal_color
        when :post_index
          @selected_color
        end.dup
        col.a *= 0.5 unless get_item(e.index)[:enabled]
        @elements[e.index].color = col
      end
    end

    private def create_colors
      @normal_color = Moon::Vector4.new(1.0, 1.0, 1.0, 1.0)
      @selected_color = Moon::Vector4.new(0.2000, 0.7098, 0.8980, 1.0000)
      @outline_color = Moon::Vector4.new(0.2000, 0.2000, 0.2000, 1.0000)
    end

    # Returns the item at the given index.
    #
    # @param [Integer] index
    # @return [Object] item at index
    def get_item(index)
      @list[index]
    end

    # Returns the item at the current @index
    #
    # @return [Object]
    def current_item
      get_item(@index)
    end

    # Finds an item given a quqry, the query will be tested against the item
    # using has_slice?
    #
    # @param [Hash<Symbol, Object>] query
    def find_item(query)
      @list.find do |d|
        d.has_slice?(query)
      end
    end

    # Sets the index by locating an item by query, see {#find_item}, the
    # index remains unchanged if the item is not found.
    #
    # @param [Hash<Symbol, Object>] query
    def jump_to_item(query)
      @index = @list.index(find_item(query)) || @index
    end

    # @param [Hash] item
    def on_item_added(item)
      text = Moon::Label.new(item[:name], @font)
      text.position.set(0, font.size * @elements.size, 0)
      text.color = @normal_color
      text.outline_color = @outline_color
      text.outline = 2
      add text
      # invalidate w and h
      resize nil, nil
      # reset index
      old_index = index
      self.index = @list.size - 1
      self.index = old_index
    end

    # Adds a new item to the list, :name will be used as the label
    #
    # @param [Object] id
    # @param [String] name
    def add_entry(id, options)
      item = { id: id, enabled: true, name: id.to_s.capitalize }.merge(options)
      @list.push(item)
      on_item_added(item)
    end

    # Wraps the provided index around the list size
    #
    # @param [Integer] new_index
    private def treat_index(new_index)
      new_index % @list.size.max(1)
    end
  end
end
