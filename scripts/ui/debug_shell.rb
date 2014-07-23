class DebugShell < RenderContainer
  class DebugContext
    #
  end

  def initialize
    super
    font = ES.cache.font("uni0553", 16)
    self.width = Screen.width
    self.height = 16 * 6

    @input_background = SkinSlice9.new
    @input_background.windowskin = Spritesheet.new("media/ui/console_windowskin_dark_16x16.png", 16, 16)

    @seperator = SkinSlice3.new
    @seperator.windowskin = Spritesheet.new("media/ui/line_96x1_ff777777.png", 32, 1)

    @caret = Caret.new

    @history = []
    @contents = []
    @input_text = Text.new("", font)
    @log_text = Text.new("", font)
    @log_text.line_height = 1
    @context = Moon::Context.new

    @input_text.color = Vector4.new(1, 1, 1, 1)
    @log_text.color = Vector4.new(1, 1, 1, 1)

    @input_background.width = width
    @input_background.height = height
    @seperator.width = width
    @seperator.height = 1

    @log_text.position.set(4, 4-8, 0)
    @input_text.position.set(4,5*height/6+4-8, 0)
    @seperator.position.set(0, @input_text.y, 0)
    @caret.position.set(@input_text.x, @input_text.position.y+2, 0)

    add(@input_background)
    add(@seperator)
    add(@input_text)
    add(@log_text)
    add(@caret)
  end

  def string
    @input_text.string
  end

  def string=(string)
    @input_text.string = string
    @input_text.color.set(1, 1, 1, 1)
    @caret.position.x = @input_text.x + @input_text.width
  end

  def exec
    begin
      @contents << ">> #{string}"
      result = @context.eval(string).to_s
      @history << result
      @contents << result
      self.string = ""
    rescue Exception => ex
      @contents << ex.message
      @input_text.color.set(1, 0, 0, 1)
    end

    @contents = @contents.last(5)
    @log_text.string = @contents.join("\n")
  end

  def render(x=0, y=0, z=0, options={})
    super
  end
end
