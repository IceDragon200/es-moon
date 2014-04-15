module ES
  module Config

    keys = Moon::Input::Keyboard::Keys
    @controls = {
      up:     [keys::UP,     keys::W],
      left:   [keys::LEFT,   keys::A],
      right:  [keys::RIGHT,  keys::D],
      down:   [keys::DOWN,   keys::S],
      accept: [keys::ENTER,  keys::Z],
      cancel: [keys::ESCAPE, keys::X],
      action: [keys::ESCAPE, keys::C],
    }

    def self.control(button)
      @controls[button]
    end

    class << self
      attr_accessor :controls
    end

  end
end