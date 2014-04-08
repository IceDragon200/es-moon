module Cache

  branch :icon do |hsh|

    hsh.default_proc = lambda do |filename, *args|
      Moon::Sprite.new("media/icons_64x64/" + filename)
    end

  end

  branch :font do |hsh|

    hsh["ipaexg"] = ->(size) do
      Moon::Font.new("resources/fonts/ipaexg/ipaexg.ttf", size)
    end

    hsh["vera"] = ->(size) do
      Moon::Font.new("resources/fonts/vera/Vera.ttf", size)
    end

    hsh["vera_mono"] = ->(size) do
      Moon::Font.new("resources/fonts/vera/VeraMono.ttf", size)
    end

    hsh["vera_mono_bold_italic"] = ->(size) do
      Moon::Font.new("resources/fonts/vera/VeraMoBI.ttf", size)
    end

    hsh["vera_mono_bold"] = ->(size) do
      Moon::Font.new("resources/fonts/vera/VeraMoBd.ttf", size)
    end

    hsh["vera_mono_italic"] = ->(size) do
      Moon::Font.new("resources/fonts/vera/VeraMoIt.ttf", size)
    end

  end

end