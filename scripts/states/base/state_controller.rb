class StateController
  attr_reader :model
  attr_reader :view

  def initialize(model, view)
    @model, @view = model, view
    init_controller
  end

  def init_controller
    #
  end

  def post_init
    @model.post_init
    @view.post_init
  end

  def update_controller(delta)
    #
  end

  def update(delta)
    update_controller(delta)
    @model.update(delta)
    @view.update(delta)
  end

  private :init_controller
  private :update_controller
end
