module ES
  class FetchOnlyHash
    def initialize(hash)
      @hash = hash
    end

    def [](key)
      @hash.fetch(key)
    end
  end

  class EsCache < Moon::CacheBase
  end

  class TextureCache < EsCache
    private def load_texture(filename)
      Moon::Texture.new(filename)
    end

    cache def block(filename)
      load_texture("resources/blocks/" + filename)
    end

    cache def icon(filename)
      load_texture("resources/icons_64x64/" + filename)
    end

    cache def bmpfont(filename)
      load_texture("resources/bmpfont/" + filename)
    end

    cache def tileset(filename)
      load_texture("resources/tilesets/" + filename)
    end

    cache def system(filename)
      load_texture("resources/system/" + filename)
    end
  end

  class FontCache < EsCache
    def post_init
      super
      @aliases = {}

      @aliases["awesome"] = "fontawesome-webfont.ttf"

      @aliases["foundation"] = "general_foundicons.ttf"
      @aliases["foundation_enclosed"] = "general_enclosed_foundicons.ttf"

      @aliases["uni0553"] = "uni0553/uni0553-webfont.ttf"
      @aliases["uni0554"] = "uni0554/uni0554-webfont.ttf"
      @aliases["uni0563"] = "uni0563/uni0563-webfont.ttf"
      @aliases["uni0564"] = "uni0564/uni0564-webfont.ttf"

      @aliases["ipaexg"] = "ipaexg00201/ipaexg.ttf"

      @aliases["vera"] = "vera/Vera.ttf"
      @aliases["vera_mono"] = "vera/VeraMono.ttf"
      @aliases["vera_mono_bold_italic"] = "vera/VeraMoBI.ttf"
      @aliases["vera_mono_bold"] = "vera/VeraMoBd.ttf"
      @aliases["vera_mono_italic"] = "vera/VeraMoIt.ttf"
    end

    cache def f(filename, size)
      Moon::Font.new("resources/fonts/" + filename, size)
    end

    def font(subname, size)
      f(@aliases[subname] || subname, size)
    end
  end

  class DataCache < EsCache
    cache def palette
      FetchOnlyHash.new(PaletteParser.load_palette(DataSerializer.load_file("palette")))
    end

    cache def controlmap(filename)
      FetchOnlyHash.new(DataSerializer.load_file("controlmaps/#{filename}"))
    end

    cache def charmap(filename)
      DataSerializer.load_file("charmap/#{filename}")
    end
  end

  class << self
    attr_accessor :texture_cache
    attr_accessor :data_cache
    attr_accessor :font_cache
  end

  def self.init_caches
    @texture_cache = TextureCache.new("Texture")
    @data_cache = DataCache.new("Data")
    @font_cache = FontCache.new("Font")
  end
end
