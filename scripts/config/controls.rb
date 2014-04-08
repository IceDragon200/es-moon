module ES
  module Config

    @controls = {
      up:     [Moon::Input::Keyboard::Keys::UP],
      left:   [Moon::Input::Keyboard::Keys::LEFT],
      right:  [Moon::Input::Keyboard::Keys::RIGHT],
      down:   [Moon::Input::Keyboard::Keys::DOWN],
      accept: [Moon::Input::Keyboard::Keys::ENTER],
      cancel: [Moon::Input::Keyboard::Keys::ESCAPE]
    }

    class << self
      attr_accessor :controls
    end

  end
end