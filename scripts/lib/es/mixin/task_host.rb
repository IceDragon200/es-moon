module TaskHost

  attr_accessor :tasks

  def add_task(*args, &block)
    @tasks ||= []
    @tasks.push Timeout.new(*args, &block)
  end

  def update_tasks(delta)
    return unless @tasks && !@tasks.empty?

    dead = []

    @tasks.each do |task|
      task.update delta
      dead << task if task.done?
    end

    @tasks -= dead
  end

end