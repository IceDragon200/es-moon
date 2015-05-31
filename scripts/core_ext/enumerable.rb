module Enumerable
  # Counts all instances of the object in the enum.
  #
  # @param [Object] obj
  # @return [Integer]
  def count(obj)
    reduce(0) { |r, e| r += 1 if e == obj; r }
  end unless method_defined? :count
end
