module Roadmap
  class StateCharacterMovement < State
    def init
      super
      @world = World.new
      @world.register :movement
      @char = @world.spawn
      @char_renderer = CharacterRenderer.new
      @char_renderer.character_attr = @char.add(:character,
                                                filename: "es-oryx/4x/character_4x.png",
                                                cell_w: 32,
                                                cell_h: 32)
      @char_renderer.position_attr = @char.add(:position)
      @char.add(:velocity)

      velo = 2

      @input.on :press, :left do
        @char[:velocity].x = -velo
      end

      @input.on :release, :left do
        @char[:velocity].x = 0
      end

      @input.on :press, :right do
        @char[:velocity].x = velo
      end

      @input.on :release, :right do
        @char[:velocity].x = 0
      end

      @input.on :press, :up do
        @char[:velocity].y = -velo
      end

      @input.on :release, :up do
        @char[:velocity].y = 0
      end

      @input.on :press, :down do
        @char[:velocity].y = velo
      end

      @input.on :release, :down do
        @char[:velocity].y = 0
      end
    end

    def update(delta)
      @world.update(delta)
      super delta
    end

    def render
      super
      @char_renderer.render(0, 0, 0)
    end
  end
end
