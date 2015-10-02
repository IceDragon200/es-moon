module Moon
  module UiEvent
    attr_accessor :parent
    attr_accessor :target
  end

  class MouseHoverEvent
    include UiEvent
  end

  class ClickEvent
    include UiEvent
  end

  module Eventable
    attr_reader :listeners
  end

  module RenderPrimitive
    module Containable
      module Parent
        # @yieldparam [Containable]
        def each_child

        end
      end
    end
  end

  class UiObserverBase
    include Activatable
    include Eventable
    include Taggable

    attr_reader :element
    attr_accessor :active
    attr_accessor :tags

    def initialize(element)
      @element = element
      @allowed = nil
      @tags = []
      initialize_eventable
      activate
    end

    def on(*args, &block)
      super(*args, &block)
      invalidate
    end

    def off(*args, &block)
      super(*args, &block)
      invalidate
    end

    # @param [Event] event
    # @return [Boolean]
    def allow_event?(event)
      return true if allowed.include?(:any)
      allowed.include?(event.type)
    end

    # @param [Event, nil] event
    # @yieldparam [Eventable] self
    # @yieldparam [Event] event
    def trigger(event = nil)
      event = yield self if block_given?
      return unless allow_event?(event)

      # TODO: support :any
      [:any, event.type].each do |type|
        @listeners[type].each do |pair|
          block, reducer = *pair
          # we can do buffering in the future
          transduce(reducer, :<<.to_proc, [], [event]).each do |e|
            block.call(e) # e, self?
          end
        end
      end
    end
  end

  class UiObserverCapture < UiObserverBase
    # Invalidates allowed events for this observer, as well as its parents
    def invalidate
      puts "Invalidating Capture input for #{@element}"
      @allowed = nil
      if p = @element.parent
        p.input.invalidate
      end
    end

    # @return [Array<Symbol>]
    private def child_event_types
      result = []
      element.each_child do |child|
        result |= child.input.allowed
      end
      result
    end

    # @return [Array<Symbol>]
    def allowed
      @allowed ||= @listeners.keys | child_event_types
    end

    # @param [Event] event
    def children_capture_event(event, &block)
      block ||= ->(elm, ev) { }
      element.each_child do |child|
        if event.is_a?(UiEvent)
          event.parent = element
          event.target = child
        end
        block.call(child, event)
        child.input.capture_event(event, &block)
      end
    end

    # @param [Event] event
    def capture_event(event, &block)
      case event
      when ClickEvent
        return unless element.screen_bounds.contains?(event.position)
      end
      trigger(event)
      children_capture_event(event, &block) if allow_event?(event)
    end
  end

  class UiObserverBubble < UiObserverBase
    # Invalidates allowed events for this observer, as well as its children
    def invalidate
      puts "Invalidating Bubble input for #{@element}"
      @allowed = nil
      @element.each_child do |child|
        child.input_bubble.invalidate
      end
    end

    # @return [Array<Symbol>]
    private def parent_event_types
      result = []
      element.each_parent do |parent, s|
        result |= parent.input_bubble.allowed
      end
      result
    end

    # @return [Array<Symbol>]
    def allowed
      @allowed ||= @listeners.keys | parent_event_types
    end

    # @param [Event] event
    def parent_bubble_event(event, &block)
      block ||= ->(elm, ev) { }
      element.each_parent do |target, parent|
        if event.is_a?(UiEvent)
          event.parent = parent
          event.target = target
        end
        block.call(target, event)
        target.input_bubble.bubble_event(event, &block)
      end
    end

    # @param [Event] event
    def bubble_event(event, &block)
      case event
      when ClickEvent
        return unless element.screen_bounds.contains?(event.position)
      end
      trigger(event)
      parent_bubble_event(event, &block) if allow_event?(event)
    end
  end

  class UiEventStates
    attr_accessor :expecting_release
    attr_accessor :last_click

    def initialize
      @expecting_release = {}
      @last_click = {}
    end
  end

  module UiEventable
    private def handle_release(e)
      if @event_states.expecting_release[e.key]
        @event_states.expecting_release[e.key] = false
        event = ClickEvent.new(self, e.position, e.button, :click)
        input.children_capture_event event
        if last = @event_states.last_click[e.button]
          if (@tick - last) < 0.5
            dblclick_ev = ClickEvent.new(event.parent, event.position, event.button, :dblclick)
            input.children_capture_event dblclick_ev
          end
        end
        @event_states.last_click[e.button] = @tick
      end
    end

    private def handle_mouse_event(e)
      p = e.position
      return unless screen_bounds.contains?(p.x, p.y)
      case e.key
      when :mouse_left, :mouse_right, :mouse_middle,
           :mouse_button_4, :mouse_button_5, :mouse_button_6, :mouse_button_7,
           :mouse_button_8
        if e.action == :release
          handle_release(e)
        else
          @event_states.expecting_release[e.key] = true
        end
      end
    end

    private def handle_mousemove_event(e)
      p = e.position
      hover_event = MouseHoverEvent.new(e, self, p, false)
      input.children_capture_event hover_event do |elm, ev|
        ev.state = elm.screen_bounds.contains?(p.x, p.y)
      end
    end

    protected def initialize_events
      super
      @event_states = UiEventStates.new
      input.on :any do |e|
        case e.type
        when :mousemove
          handle_mousemove_event e
        when :press, :release
          handle_mouse_event e if e.is_a?(MouseEvent)
        end
        input.children_capture_event e
      end
    end
  end

  module AffectsParentSize
    attr_accessor :affects_parent_size

    # @param [Hash<Symbol, Object>] options
    protected def initialize_from_options(options)
      super
      @affects_parent_size = options.fetch(:affects_parent_size, true)
    end
  end

  class RenderContext
    prepend AffectsParentSize
    remove_method :enable_default_events

    attr_accessor :input_bubble

    protected def initialize_input
      @input = UiObserverCapture.new self
      @input_bubble = UiObserverBubble.new self
    end

    def on_resize(*attrs)
      super
      if parent.is_a?(ContainerChildResize)
        parent.refresh_size if @affects_parent_size
      end
    end

    def each_child
    end

    def each_parent
      p = self
      t = p.parent
      while t
        yield t, p
        p = t
        t = p.parent
      end
    end
  end

  module UiEventableContainer
    protected def on_child_adopt(child)
      super
      input.invalidate
      child.input_bubble.invalidate
    end

    protected def on_child_disown(child)
      super
      input.invalidate
      child.input_bubble.invalidate
    end
  end

  module ContainerChildResize
    attr_accessor :auto_resize

    # @param [RenderContext] child
    def refresh_size
      super if @auto_resize
    end

    protected def initialize_members
      super
      @auto_resize = true
    end

    # @param [Hash<Symbol, Object>] options
    protected def initialize_from_options(options)
      super
      @auto_resize = options.fetch(:auto_resize, @auto_resize)
    end
  end

  class RenderContainer
    prepend UiEventableContainer
    prepend ContainerChildResize

    protected def initialize_events
      super
    end

    # all elements which affect the size of the RenderContainer
    private def sized_elements
      @elements.select(&:affects_parent_size)
    end

    # @return [Integer]
    private def compute_w
      x, _, x2, _ = *Moon::Rect.bb_for(sized_elements)
      x2 - x
    end

    # @return [Integer]
    private def compute_h
      _, y, _, y2 = *Moon::Rect.bb_for(sized_elements)
      y2 - y
    end

    def each_child(&block)
      @elements.each(&block)
    end
  end

  class UiRoot < RenderContainer
    include UiEventable
  end
end
