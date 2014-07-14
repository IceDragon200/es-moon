class Array
  def singularize
    size > 1 ? self : first
  end
end
