module Moon
  module Input
    KEY_TO_HUMAN = {
      SPACE => %w[Spacebar],
      APOSTROPHE => %w[' "],
      COMMA => %w[, <],
      MINUS => %w[- _],
      PERIOD => %w[. >],
      SLASH => %w[/ ?],
      N0 => %w[0 )],
      N1 => %w[1 !],
      N2 => %w[2 @],
      N3 => %w[3 #],
      N4 => %w[4 $],
      N5 => %w[5 %],
      N6 => %w[6 ^],
      N7 => %w[7 &],
      N8 => %w[8 *],
      N9 => %w[9 (],
      SEMICOLON => %w[; :],
      EQUAL => %w[= +],
      A => %w[a A],
      B => %w[b B],
      C => %w[c C],
      D => %w[d D],
      E => %w[e E],
      F => %w[f F],
      G => %w[g G],
      H => %w[h H],
      I => %w[i I],
      J => %w[j J],
      K => %w[k K],
      L => %w[l L],
      M => %w[m M],
      N => %w[n N],
      O => %w[o O],
      P => %w[p P],
      Q => %w[q Q],
      R => %w[r R],
      S => %w[s S],
      T => %w[t T],
      U => %w[u U],
      V => %w[v V],
      W => %w[w W],
      X => %w[x X],
      Y => %w[y Y],
      Z => %w[z Z],
      LEFT_BRACKET => %w([ {),
      BACKSLASH => %w[\\ |],
      RIGHT_BRACKET => %w(] }),
      GRAVE_ACCENT => %w[` ~],
      WORLD_1 => %w[],
      WORLD_2 => %w[],
      ESCAPE => %w[ESC],
      ENTER => %w[Return],
      TAB => %w[Tab],
      BACKSPACE => %w[Backspace],
      INSERT => %w[Insert],
      DELETE => %w[Delete],
      RIGHT => %w[Right],
      LEFT => %w[Left],
      DOWN => %w[Down],
      UP => %w[Up],
      PAGE_UP => %w[Page-Up],
      PAGE_DOWN => %w[Page-Down],
      HOME => %w[Home],
      const_get(:END) => %w[End],
      CAPS_LOCK => %w[Caps-Lock],
      SCROLL_LOCK => %w[Scroll-Lock],
      NUM_LOCK => %w[Num-Lock],
      PRINT_SCREEN => %w[Print-Screen],
      PAUSE => %w[Pause],
      F1 => %w[F1],
      F2 => %w[F2],
      F3 => %w[F3],
      F4 => %w[F4],
      F5 => %w[F5],
      F6 => %w[F6],
      F7 => %w[F7],
      F8 => %w[F8],
      F9 => %w[F9],
      F10 => %w[F10],
      F11 => %w[F11],
      F12 => %w[F12],
      F13 => %w[F13],
      F14 => %w[F14],
      F15 => %w[F15],
      F16 => %w[F16],
      F17 => %w[F17],
      F18 => %w[F18],
      F19 => %w[F19],
      F20 => %w[F20],
      F21 => %w[F21],
      F22 => %w[F22],
      F23 => %w[F23],
      F24 => %w[F24],
      F25 => %w[F25],
      KP_0 => %w[Numpad-0],
      KP_1 => %w[Numpad-1],
      KP_2 => %w[Numpad-2],
      KP_3 => %w[Numpad-3],
      KP_4 => %w[Numpad-4],
      KP_5 => %w[Numpad-5],
      KP_6 => %w[Numpad-6],
      KP_7 => %w[Numpad-7],
      KP_8 => %w[Numpad-8],
      KP_9 => %w[Numpad-9],
      KP_DECIMAL => %w[Numpad-.],
      KP_DIVIDE => %w[Numpad-/],
      KP_MULTIPLY => %w[Numpad-*],
      KP_SUBTRACT => %w[Numpad--],
      KP_ADD => %w[Numpad-+],
      KP_ENTER => %w[Numpad-Return],
      KP_EQUAL => %w[Numpad-=],
      LEFT_SHIFT => %w[Left-Shift],
      LEFT_CONTROL => %w[Left-Control],
      LEFT_ALT => %w[Left-Alt],
      LEFT_SUPER => %w[Left-Super],
      RIGHT_SHIFT => %w[Right-Shift],
      RIGHT_CONTROL => %w[Right-Control],
      RIGHT_ALT => %w[Right-Alt],
      RIGHT_SUPER => %w[Right-Super],
      MENU => %w[Menu],
      MOUSE_BUTTON_1 => %w[Mouse-Button-1],
      MOUSE_BUTTON_2 => %w[Mouse-Button-2],
      MOUSE_BUTTON_3 => %w[Mouse-Button-3],
      MOUSE_BUTTON_4 => %w[Mouse-Button-4],
      MOUSE_BUTTON_5 => %w[Mouse-Button-5],
      MOUSE_BUTTON_6 => %w[Mouse-Button-6],
      MOUSE_BUTTON_7 => %w[Mouse-Button-7],
      MOUSE_BUTTON_8 => %w[Mouse-Button-8],
      MOUSE_LEFT => %w[Mouse-Left],
      MOUSE_RIGHT => %w[Mouse-Right],
      MOUSE_MIDDLE => %w[Mouse-Middle],
    }

    def self.key_to_human_readable(key)
      KEY_TO_HUMAN[convert_key(key)]
    end
  end
end