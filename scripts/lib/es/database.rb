module ES
  module Database

    @class_reg = {
      chunk: ES::DataModel::Chunk
    }

    @data = {}

    def self.clear(sub)
      (sub ? (@data[sub]||[]) : @data).clear
    end

    def self.create(sub, options={})
      entries = (@data[sub] ||= [])

      obj = @class_reg[sub].new({ id: entries.size }.merge(options))

      entries[obj.id] = obj

      yield obj if block_given?

      obj
    end

    def self.where(sub, options={})
      if block_given?
        @data[sub].select { |e| yield e }
      else
        return @data[sub] if options.empty?
        @data[sub].select do |e|
          options.all? { |k, v| e.send(k) == v }
        end
      end
    end

    def self.find(sub, options={}, &block)
      where(sub, options, &block).first
    end

  end
end