module Enumerable
  # Counts all instances of the object in the enum.
  #
  # @param [Object] obj
  # @return [Integer]
  def count(obj = nil, &block)
    block ||= -> (b) { obj == b }
    reduce(0) { |r, e| r += 1 if block.call(e); r }
  end unless method_defined? :count
end
