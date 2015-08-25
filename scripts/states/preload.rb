module States
  class Preload < Base
    def start
      super
      load_assets
      load_vfs
      load_materials

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

    def load_vfs
      ## maps
      vfs = YAML.load_file('data/vfs.yml')['data']
      vfs.each_pair do |key, entries|
        klass = case key
        when 'characters'
          ES::Character
        when 'maps'
          ES::Map
        when 'charmaps'
          next
        when 'tilesets'
          ES::Tileset
        else
          fail "Unhandled data key #{key}"
        end

        entries.each do |filename|
          klass.load_file filename.gsub('.yml', '')
        end
      end
    end

    def load_assets
      assets = YAML.load_file('data/preload.yml')
      assets.each_pair do |key, value|
        case key
        when 'textures'
          textures = {}
          value.each_pair do |name, filename|
            puts "Preloading Texture: #{filename}"
            texture = textures[filename] ||= Moon::Texture.new(filename)
            game.texture_cache.cache(name, texture)
          end
        when 'fonts'
          fonts = {}
          value.each_pair do |name, str|
            filename, size = str.split(',')
            puts "Preloading Font: #{str}"
            font = fonts[str] ||= Moon::Font.new(filename, size.to_i)
            game.font_cache.cache(name, font)
          end
        end
      end
    end

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
