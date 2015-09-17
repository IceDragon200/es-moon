module Moon
  class Scheduler
    # Creates a new Transition job in the scheduler, see {Moon::Transition},
    # and (Moon::Scheduler#add) for parameters and details.
    #
    # @return [Moon::Transition]
    def transition(*args, &block)
      add Moon::Transition.new(*args, &block)
    end
  end
end
