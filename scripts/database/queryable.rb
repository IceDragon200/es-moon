module Database
  module Queryable
    # @param [Symbol] key
    # @param [Object] value
    def query(key, value)
      send(key) == value
    end
  end
end
