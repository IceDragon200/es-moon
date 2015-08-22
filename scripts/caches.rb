require 'scripts/core/fetch_only_hash'

module ES
  class TextureCache < Moon::CacheBase
    cache def texture(filename)
      Moon::Texture.new(filename)
    end

    cache def resource(filename)
      texture('resources/' + filename)
    end

    cache def block(filename)
      resource('blocks/' + filename)
    end

    cache def icon(filename)
      resource('icons_64x64/' + filename)
    end

    cache def bmpfont(filename)
      resource('bmpfont/' + filename)
    end

    cache def tileset(filename)
      resource('tilesets/' + filename)
    end

    cache def system(filename)
      resource('system/' + filename)
    end

    cache def gauge(filename)
      resource('gauges/' + filename)
    end

    cache def ui(filename)
      resource('ui/' + filename)
    end

    cache def background(filename)
      resource('backgrounds/' + filename)
    end
  end

  class FontCache < Moon::CacheBase
    def post_initialize
      super
      @aliases = {}

      @aliases['awesome'] = 'fontawesome-webfont.ttf'

      @aliases['foundation'] = 'general_foundicons.ttf'
      @aliases['foundation_enclosed'] = 'general_enclosed_foundicons.ttf'

      @aliases['uni0553'] = 'uni0553/uni0553-webfont.ttf'
      @aliases['uni0554'] = 'uni0554/uni0554-webfont.ttf'
      @aliases['uni0563'] = 'uni0563/uni0563-webfont.ttf'
      @aliases['uni0564'] = 'uni0564/uni0564-webfont.ttf'

      @aliases['ipaexg'] = 'ipaexg00201/ipaexg.ttf'

      @aliases['vera'] = 'vera/Vera.ttf'
      @aliases['vera_mono'] = 'vera/VeraMono.ttf'
      @aliases['vera_mono_bold_italic'] = 'vera/VeraMoBI.ttf'
      @aliases['vera_mono_bold'] = 'vera/VeraMoBd.ttf'
      @aliases['vera_mono_italic'] = 'vera/VeraMoIt.ttf'

      @aliases['system'] = @aliases['uni0553']
    end

    cache def f(filename, size)
      Moon::Font.new('resources/fonts/' + filename, size)
    end

    def font(subname, size)
      f(@aliases[subname] || subname, size)
    end
  end

  class DataCache < Moon::CacheBase
    cache def palette
      data = Moon::DataSerializer.load_file('palette')
      palette = Moon::PaletteParser.load_palette(data)
      FetchOnlyHash.new(palette)
    end

    cache def controlmap(filename)
      FetchOnlyHash.new(Moon::DataSerializer.load_file("controlmaps/#{filename}"))
    end

    cache def charmap(filename)
      Moon::DataSerializer.load_file("charmap/#{filename}")
    end
  end
end
