module Activatable
  attr_accessor :active

  def activate
    @active = true
  end

  def deactivate
    @active = false
  end

  alias :active? :active
end
