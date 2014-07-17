class StateMusicLayering < State
  def init
    super
    @music_drums = Music.new("media/music/MoonMusicTest_Drums.ogg", "ogg")
    @music_marimba = Music.new("media/music/MoonMusicTest_Marimba.ogg", "ogg")
    @music_piano = Music.new("media/music/MoonMusicTest_Piano.ogg", "ogg")
    @music_drums.loop
    @music_marimba.loop
    @music_piano.loop
    @ss = ES.cache.block("a064x064.png", 64, 64)

    @input.on :press, :n1 do
      toggle_clip(@music_drums)
    end

    @input.on :press, :n2 do
      toggle_clip(@music_marimba)
    end

    @input.on :press, :n3 do
      toggle_clip(@music_piano)
    end
  end

  def toggle_clip(clip)
    if clip.playing?
      clip.stop
    else
      track = [@music_drums, @music_marimba, @music_piano].find(&:playing?)
      clip.seek(track ? track.pos : 0)
      clip.play
    end
  end

  def update(delta)
    super(delta)
  end

  def render
    @ss.render(0, 0, 0, 4) if @music_drums.playing?
    @ss.render(64, 0, 0, 5) if @music_marimba.playing?
    @ss.render(128, 0, 0, 6) if @music_piano.playing?
    super
  end
end
