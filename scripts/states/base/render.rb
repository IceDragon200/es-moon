module States
  class Base
    protected def create_render_contexts
      @renderer = Moon::UiRoot.new
      @renderer.tag 'renderer'

      @gui = Moon::UiRoot.new
      @gui.tag 'gui'
    end
  end
end
