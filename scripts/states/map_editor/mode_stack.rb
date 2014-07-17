class ModeStack
  attr_accessor :on_mode_change

  def initialize
    @list = []
    @on_mode_change = nil
  end

  def current
    @list.last
  end

  def push(mode)
    @list.push mode
    @on_mode_change.try(:call, mode)
    puts @list
  end

  def change(mode)
    @list[-1] = mode
    @on_mode_change.try(:call, mode)
    puts @list
  end

  def pop
    @list.pop
    @on_mode_change.try(:call, @list.last)
    puts @list
  end

  def is?(mode)
    current == mode
  end

  def has?(mode)
    @list.include?(mode)
  end

  def starts_with?(*modes)
    modes.each_with_index.all? do |mode, i|
      @list[i] == mode
    end
  end

  def trace?(modes)
    @list == modes
  end

  def [](index)
    @list[index]
  end
end
