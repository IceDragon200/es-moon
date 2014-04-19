module Cache

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

  branch :font do

    hsh = {}

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

    hsh
  end

end