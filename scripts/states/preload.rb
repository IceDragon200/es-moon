require 'scripts/states/test/ui'

module States
  # State responsible for preloading all assets that will be used in the game
  # This is to avoid runtime allocations, and forces thinking ahead instead
  # of "maybe I'll use this"
  class Preload < Base
    class IdentityLoader
      # Place holder Loader for data classes without a schema, this loader
      # will just return the data passed in.
      #
      # @param [Object] data
      # @return [Object] data
      def self.load(data)
        data
      end
    end

    class ReadOnlyLoader
      # This loader will wrap the data in a FetchOnlyHash
      #
      # @param [Hash] data
      # @return [FetchOnlyHash] data
      def self.load(data)
        FetchOnlyHash.new(data)
      end
    end

    class ControlmapLoader
      # This loader will transform a controlmap hash by converting all its
      # string values to symbols and wrap then in an Array
      #
      # @param [Hash] data
      # @return [FetchOnlyHash] data
      def self.load(data)
        result = Hash[data.map do |key, value|
          [key, Array(value).map(&:to_sym)]
        end]
        FetchOnlyHash.new(result)
      end
    end

    class PaletteLoader
      # This loader will load a valid PalleteParser palette and
      # wrap the data in a FetchOnlyHash
      #
      # @param [Hash] data
      # @return [FetchOnlyHash] data
      def self.load(data)
        FetchOnlyHash.new Moon::PaletteParser.load_palette(data)
      end
    end

    class MapLoader
      # This loader wraps the Models::Map and patches the map data
      #
      # @param [Hash] data  a map dump
      # @return [Models::Map]
      def self.load(data)
        map = Models::Map.load(data)
        unless map.zones
          puts "WARN: #{map.id} was missing zones data"
          map.zones = Moon::DataMatrix.new(map.w, map.h, 1, default: -1)
        end
        map
      end
    end

    class VfsLoader
      # @return [Game]
      attr_reader :game

      # @param [String] key
      # @param [Game] game
      # @param [String] root  root path
      # @param [#load] loader
      def initialize(key, game, root, loader)
        @key = key
        @game = game
        @root = root
        @loader = loader
      end

      # @param [String] subpath  path to concat to the current root
      # @return [VfsLoader] a new instance with its root changed
      private def new(subpath)
        VfsLoader.new(@key, @game, File.join(@root, subpath), @loader)
      end

      # @param [String] basename of the filename
      private def load_record(basename)
        filename = File.join(@root, basename)
        cachename = filename.gsub(/#{File.extname(filename)}\z/, '').gsub(/\Adata\//, '')
        data = YAML.load_file(filename)
        record = @loader.load(data)
        record.id = cachename if record.respond_to?(:id=)
        @game.database[cachename] = record
        puts "Preloaded #{@key} data: #{cachename}=#{filename}"
      end

      # @param [String] basename of the filename
      private def load_import(basename)
        filename = File.join(@root, basename)
        import_loader = new(File.dirname(basename))
        data = YAML.load_file(filename)
        data.each { |name| import_loader.load(name) }
      end

      # @param [String] basname
      public def load(basename)
        if basename =~ /\A&import:(.+)/
          load_import($1)
        else
          load_record(basename)
        end
      end
    end

    # @return [void]
    def start
      super
      @loaders = {
        'characters' => Models::Character,
        'maps' => MapLoader,
        'tilesets' => Models::Tileset,
        'palette' => PaletteLoader,
        'read_only' => ReadOnlyLoader,
        'data' => IdentityLoader,
        'controlmap' => ControlmapLoader,
      }

      load_assets
      load_vfs
      load_materials

      game.font_cache.lock
      game.texture_cache.lock

      state_manager.change States::Shutdown
      state_manager.push States::Title
      #state_manager.push States::Test::UI
      # Test Map
      #state_manager.push States::FpMap
      ## Roadmap tests
      #state_manager.push Roadmap::StateGridBasedCharacterMovement
      #state_manager.push Roadmap::StateCharacterMovement
      #state_manager.push Roadmap::StateDisplaySpriteOnTilemap
      #state_manager.push Roadmap::StateDisplayTilemapWithChunks
      #state_manager.push Roadmap::StateDisplayChunk
      #state_manager.push Roadmap::StateDisplaySpriteOnScreen

      #state_manager.push StateMusicLayering
      #state_manager.push StateCharacterWalkTest
      #state_manager.push StateTypingTest
      #state_manager.push StateUITest01

      # Splash screens
      if game.config[:splash]
        state_manager.push States::EsSplash
        state_manager.push States::MoonSplash
        state_manager.push States::MrubySplash
      end
    end

    # Loads the game data from the data/vfs.yml
    #
    # @return [void]
    def load_vfs
      ## maps
      root_filename = "data/vfs.yml"
      root = File.dirname(root_filename)
      vfs = YAML.load_file(root_filename)['data']
      vfs.each_pair do |key, entries|
        loader = @loaders.fetch(key) do
          puts "WARN: Unhandled loader key #{key}"
          IdentityLoader
        end

        vfs_loader = VfsLoader.new(key, game, root, loader)
        entries.each { |basename| vfs_loader.load(basename) }
      end
    end

    # Loads all Textures, Fonts and other objects into their respective caches.
    # These objects are loaded from the data/preload.yml list
    #
    # @return [void]
    def load_assets
      assets = YAML.load_file('data/preload.yml')
      assets.each_pair do |key, value|
        case key
        when 'textures'
          textures = {}
          value.each_pair do |name, filename|
            puts "Preloading Texture: #{name}=#{filename}"
            texture = textures[filename] ||= Moon::Texture.new(filename)
            game.texture_cache[name] = texture
          end
        when 'fonts'
          fonts = {}
          value.each_pair do |name, str|
            filename, size = str.split(',')
            puts "Preloading Font: #{name}=#{str}"
            font = fonts[str] ||= Moon::Font.new(filename, size.to_i)
            game.font_cache[name] = font
          end
        end
      end
    end

    # Loads all materials that will be used in the Game
    #
    # @return [void]
    def load_materials
      game.materials['sprite'] = begin
        material = Material.new(Moon::Sprite.default_shader)
        material.set_uniform('opacity', 1.0)
        material.set_uniform('color', Color.new(255, 255, 255, 255))
        material.set_uniform('tone', Color.new(0, 0, 0, 255))
        material
      end
    end
  end
end
