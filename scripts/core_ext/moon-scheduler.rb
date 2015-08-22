module Moon
  class Scheduler
    def transition(*args, &block)
      add Moon::Transition.new(*args, &block)
    end
  end
end
