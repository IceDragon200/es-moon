module Moon
  module Eventable
    def pp_eventable
      puts "#{self}.listeners"
      @listeners.each_pair do |key, values|
        puts "\tevent :#{key}"
        values.each do |value|
          puts "\t\thandle: #{value}"
        end
      end
    end
  end
end
