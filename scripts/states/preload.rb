module States
  class Preload < Base
    def start
      super
      assets = YAML.load_file('data/preload.yml')
      assets.each_pair do |key, value|
        case key
        when 'textures'
          value.each do |filename|
            puts "Preloading Texture: #{filename}"
            game.texture_cache.texture(filename)
          end
        when 'fonts'
          value.each do |str|
            filename, size = str.split(',')
            puts "Preloading Font: #{str}"
            game.font_cache.font(filename, size.to_i)
          end
        end
      end

      state_manager.pop
    end
  end
end
