module Moon
  class Table
    def self.coerce(obj)
      if obj.is_a?(Hash)
        load obj
      else
        obj
      end
    end
  end
end
