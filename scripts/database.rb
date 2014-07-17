module ES
  module Database

    @class_reg = {
      chunk: ES::DataModel::Chunk,
      entity: ES::DataModel::Entity,
      map: ES::DataModel::Map,
      tileset: ES::DataModel::Tileset,
    }

    @data = {}

    def self.clear(sub)
      (sub ? (@data[sub]||[]) : @data).clear
    end

    def self.create(sub, options={})
      entries = (@data[sub] ||= [])

      klass = @class_reg.fetch(sub)
      obj = klass.new({ id: entries.size }.merge(options))

      entries[obj.id] = obj

      yield obj if block_given?

      obj
    end

    def self.load(sub, data)
      create sub do |obj|
        obj.import data
      end
    end

    def self.load_file(sub, filename)
      puts "[Database.load_file #{sub}] #{filename}"
      load sub, YAML.load_file(filename)
    end

    def self.load_data_file(sub, basename)
      klass = @class_reg[sub]
      load_file sub, klass.basepath + basename + ".yml"
    end

    def self.where(sub, options={})
      if block_given?
        @data[sub].select { |e| yield e }
      else
        return @data[sub] if options.empty?
        @data[sub].select do |e|
          options.all? { |k, v| e.query(k, v) }
        end
      end
    end

    def self.find(sub, options={}, &block)
      where(sub, options, &block).first
    end

  end
end
