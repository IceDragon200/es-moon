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

    hsh["uni0553"] = ->(size) do
      Moon::Font.new("resources/fonts/uni0553/uni0553-webfont.ttf", size)
    end

    hsh["uni0554"] = ->(size) do
      Moon::Font.new("resources/fonts/uni0554/uni0554-webfont.ttf", size)
    end

    hsh["uni0563"] = ->(size) do
      Moon::Font.new("resources/fonts/uni0563/uni0563-webfont.ttf", size)
    end

    hsh["uni0564"] = ->(size) do
      Moon::Font.new("resources/fonts/uni0564/uni0564-webfont.ttf", size)
    end

    hsh["ipaexg"] = ->(size) do
      Moon::Font.new("resources/fonts/ipaexg00201/ipaexg.ttf", size)
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