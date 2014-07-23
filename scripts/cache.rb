module ES
  class << self
    attr_accessor :cache
  end
  class Cache < CacheBase

    def debug
      #
    end

    class FetchOnlyHash
      def initialize(hash)
        @hash = hash
      end

      def [](key)
        @hash.fetch(key)
      end
    end

    branch :palette do
      lambda do |*args|
        FetchOnlyHash.new(PaletteParser.load_palette(YAML.load(File.read("data/palette.yml"))))
      end
    end

    branch :controlmap do
      lambda do |filename, *args|
        FetchOnlyHash.new(YAML.load(File.read("data/controlmaps/#{filename}")))
      end
    end

    branch :charmap do
      lambda do |filename, *args|
        YAML.load(File.read("data/charmap/#{filename}"))
      end
    end

    branch :block do
      lambda do |filename, *args|
        Moon::Spritesheet.new("media/blocks/" + filename, *args)
      end
    end

    branch :icon do
      lambda do |filename, *args|
        Moon::Sprite.new("media/icons_64x64/" + filename)
      end
    end

    branch :bmpfont do
      lambda do |filename, *args|
        Moon::Spritesheet.new("media/bmpfont/" + filename, *args)
      end
    end

    branch :tileset do
      lambda do |filename, *args|
        Moon::Spritesheet.new("media/tilesets/" + filename, *args)
      end
    end

    branch :system do
      lambda do |filename, *args|
        Moon::Sprite.new "media/system/" + filename
      end
    end

    branch :font do

      hsh = {}

      loader = lambda do |filename|
        ->(size) { Moon::Font.new(filename, size) }
      end

      hsh["awesome"] = loader.("resources/fonts/fontawesome-webfont.ttf")

      hsh["foundation"] = loader.("resources/fonts/general_foundicons.ttf")
      hsh["foundation_enclosed"] = loader.("resources/fonts/general_enclosed_foundicons.ttf")

      hsh["uni0553"] = loader.("resources/fonts/uni0553/uni0553-webfont.ttf")
      hsh["uni0554"] = loader.("resources/fonts/uni0554/uni0554-webfont.ttf")
      hsh["uni0563"] = loader.("resources/fonts/uni0563/uni0563-webfont.ttf")
      hsh["uni0564"] = loader.("resources/fonts/uni0564/uni0564-webfont.ttf")

      hsh["ipaexg"] = loader.("resources/fonts/ipaexg00201/ipaexg.ttf")

      hsh["vera"] = loader.("resources/fonts/vera/Vera.ttf")
      hsh["vera_mono"] = loader.("resources/fonts/vera/VeraMono.ttf")
      hsh["vera_mono_bold_italic"] = loader.("resources/fonts/vera/VeraMoBI.ttf")
      hsh["vera_mono_bold"] = loader.("resources/fonts/vera/VeraMoBd.ttf")
      hsh["vera_mono_italic"] = loader.("resources/fonts/vera/VeraMoIt.ttf")

      hsh
    end

  end
end
