module Database
  module Queryable
    def query(key, value)
      send(key) == value
    end
  end
end
