module ES
  module Config

    keys = Moon::Input::Keyboard::Keys
    @controls = {
      up:     [keys::UP],
      left:   [keys::LEFT],
      right:  [keys::RIGHT],
      down:   [keys::DOWN],
      accept: [keys::ENTER, keys::D],
      cancel: [keys::ESCAPE, keys::S]
    }

    class << self
      attr_accessor :controls
    end

  end
end