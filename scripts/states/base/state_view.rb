class StateView < RenderContainer
  def initialize(model)
    @model = model
    super()
    init_view
  end

  def init_view
    #
  end

  def update_view(delta)
    #
  end

  def update(delta)
    update_view(delta)
    super(delta)
  end

  private :init_view
  private :update_view
end
