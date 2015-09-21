require 'scripts/core/fetch_only_hash'

module ES
  # Asset caches are different from traditional moon Caches, Asset caches
  # will not load or create an new objects by itself, this forces the user
  # to preload all needed assets before usage and prevents in game loading lag.
  class AssetCache
    attr_reader :name
    attr_reader :entries

    def initialize(name)
      @name = name
      @entries = {}
      @locked = false
    end

    def lock
      @locked = true
      self
    end

    def locked?
      @locked
    end

    # Checks if the cache is locked, prints an error if it is.
    #
    # @return [Boolean]
    private def check_locked
      if locked?
        puts "WARN: AssetCache(#{@name}) is locked"
        return true
      end
      false
    end

    def clear
      return if check_locked
      @entries.clear
      self
    end

    def []=(key, value)
      return if check_locked
      @entries[key] = value
    end

    def exist?(key)
      @entries.key?(key)
    end

    def [](key)
      @entries.fetch(key)
    end

    def each_pair(&block)
      @entries.each_pair(&block)
    end
  end

  class DataCache < Moon::CacheBase
    cache def data(filename)
      Moon::DataSerializer.load_file(filename)
    end

    cache def palette
      palette = Moon::PaletteParser.load_palette(data('palette'))
      FetchOnlyHash.new(palette)
    end

    cache def controlmap(filename)
      FetchOnlyHash.new(data("controlmaps/#{filename}"))
    end

    cache def charmap(filename)
      data("charmap/#{filename}")
    end
  end
end
