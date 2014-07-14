module Containable
  include Visibility

  attr_accessor :parent

  def containerize
    container = RenderContainer.new
    container.add(self)
    container
  end
end
