class Array
  # Returns the index of the first item whose block evaluates to true
  #
  # @yieldparam [Object] elm
  # @yieldreturn [Boolean] is this the item?
  # @return [Integer, nil] index
  def index_where
    i = 0
    each do |elm|
      return i if yield(elm)
      i += 1
    end
    nil
  end

  alias :index_of :index
  # @overload index { |elm| bool }
  #   (see #index_where)
  # @overload index(obj)
  #   @param [Object] obj
  # @return [Integer, nil] index
  def index(*args, &block)
    if block_given?
      if args.size > 0
        raise ArgumentError, "either provide a block or an object, not both"
      end
      index_where(&block)
    elsif args.size == 1
      index_of(args.first)
    else
      raise ArgumentError,
        "wrong number of arguments #{args.size} (expected 0..1)"
    end
  end
end
