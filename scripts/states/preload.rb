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

    # @return [void]
    def start
      super
      load_assets
      load_vfs
      load_materials

      game.font_cache.lock
      game.texture_cache.lock

      state_manager.change States::Shutdown
      state_manager.push States::Title
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
        klass = case key
        when 'characters'
          Models::Character
        when 'maps'
          Models::Map
        when 'tilesets'
          Models::Tileset
        when 'palette'
          PaletteLoader
        when 'read_only'
          ReadOnlyLoader
        else
          puts "WARN: Unhandled data key #{key}"
          IdentityLoader
        end

        entries.each do |basename|
          filename = File.join(root, basename)
          cachename = basename.gsub(/#{File.extname(filename)}\z/, '')
          puts "Preloading #{key} data: #{cachename}=#{filename}"
          data = YAML.load_file(filename)
          record = klass.load data
          record.id = cachename if record.respond_to?(:id=)
          game.database[cachename] = record
        end
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
