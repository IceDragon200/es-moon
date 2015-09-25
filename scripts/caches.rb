require 'scripts/core/fetch_only_hash'

module ES
  # Asset caches are different from traditional moon Caches, Asset caches
  # will not load or create an new objects by itself, this forces the user
  # to preload all needed assets before usage and prevents in game loading lag.
  class AssetCache
    # @return [String]
    attr_reader :name

    # @return [Hash<String, Object>]
    attr_reader :entries

    # @param [String] name
    def initialize(name)
      @name = name
      @entries = {}
      @locked = false
    end

    # Locks the cache to prevent further modification
    #
    # @return [self]
    def lock
      @locked = true
      self
    end

    # Is the cache locked?
    #
    # @return [Boolean] true if the cache is locked, false otherwise
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

    # Clears all entries in the cache
    #
    # @return [self]
    def clear
      return if check_locked
      @entries.clear
      self
    end

    # Sets a cache entry, affected by {#locked?}
    #
    # @param [String] key
    # @param [Object] value
    def []=(key, value)
      return if check_locked
      @entries[key] = value
    end

    # Sets a cache entry, affected by {#locked?}
    #
    # @param [String] key
    # @return [Boolean]
    def exist?(key)
      @entries.key?(key)
    end

    # Entry by the name (key), raises a KeyError if the entry does not exist
    #
    # @return [Object]
    def [](key)
      @entries.fetch(key)
    end

    # Yields each key value pair in the cache
    #
    # @yieldparam [String] key
    # @yieldparam [Object] value
    def each_pair(&block)
      @entries.each_pair(&block)
    end
  end

  class SpritesheetCache < AssetCache
    protected :[]=

    def [](*args)
      filename, cell_w, cell_h = *args.singularize
      key = "#{filename},#{cell_w},#{cell_h}"
      unless exist?(key)
        texture = Game.instance.textures[filename]
        self[key] = Moon::Spritesheet.new(texture, cell_w, cell_h)
      end
      super key
    end
  end
end
