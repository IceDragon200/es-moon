module Moon
  module UiEvent
    attr_accessor :parent
    attr_accessor :target
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

  class UiObserver
    include Activatable
    include Eventable
    include Taggable

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

    def invalidate
      puts "Input invalidated for #{@element}"
      @allowed = nil
      if p = @element.parent
        p.input.invalidate
      end
    end

    private def child_events
      result = []
      if @element.is_a?(RenderPrimitive::Containable::Parent)
        @element.each_child do |child|
          result |= child.input.allowed
        end
      end
      result
    end

    def allowed
      @allowed ||= @listeners.keys | child_events
    end

    # @param [Event] event
    # @return [Boolean]
    def allow_event?(event)
      return true if allowed.include?(:any)
      allowed.include?(event.type)
    end

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

  class UiEventStates
    attr_accessor :expecting_release
    attr_accessor :last_click

    def initialize
      @expecting_release = {}
      @last_click = nil
    end
  end

  module UiEventable
    private def handle_release(e)
      if @event_states.expecting_release[e.key]
        @event_states.expecting_release[e.key] = false
        event = ClickEvent.new(self, e.position, :click)
        child_handle_event event
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

    protected def initialize_events
      super
      @event_states = UiEventStates.new
      input.on :any do |e|
        case e.type
        when :press, :release
          handle_mouse_event e if e.is_a?(MouseEvent)
        when :click
          if @event_states.last_click
            if (@tick - @event_states.last_click) < 0.5
              trigger { ClickEvent.new(e.parent, e.position, :dblclick) }
            end
          end
          @event_states.last_click = @tick
        end
        child_handle_event e
      end
    end
  end

  class RenderContext
    remove_method :enable_default_events

    protected def initialize_input
      @input = UiObserver.new self
    end

    # @param [Event] event
    def handle_event(event)
      input.trigger(event)
    end

    def on_resize(*attrs)
      super
      if parent.is_a?(RenderContainer)
        parent.refresh_size
      end
    end
  end

  module UiEventableContainer
    protected def on_child_adopt(child)
      super
      input.invalidate
    end

    protected def on_child_disown(child)
      super
      input.invalidate
    end
  end

  class RenderContainer
    protected def initialize_events
      super
    end

    prepend UiEventableContainer

    def each_child(&block)
      @elements.each(&block)
    end

    def child_handle_event(event)
      each_child do |element|
        if event.is_a?(UiEvent)
          event.parent = self
          event.target = element
        end
        element.handle_event(event)
      end
    end

    def handle_event(event)
      super
      if input.allow_event?(event)
        child_handle_event event
      end
    end
  end

  class UiRoot < RenderContainer
    include UiEventable
  end
end
