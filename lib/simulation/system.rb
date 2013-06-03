module Simulation
  class System

    attr_accessor :state

    def initialize(system = {})
      @state = system
      @state[:time] ||= 0
    end

    # Enables updating the chosen components of the system
    # in the way similar to Hash#merge!
    # 
    # Validates time. Should you need more validations
    # subclass Simulation::System and overwrite Simulation::System#merge!
    # Remember to call super, otherwise the time will not be checked.
    def update(new_state)
      if new_state.is_a? Simulation::System
        merge!(new_state.state)
      else
        merge!(new_state)
      end
    end

    def merge!(values)
      if values.has_key? :time
        valid_time?(values[:time]) ? @state.merge!(values) : raise InvalidTimeError
      else
        @state.merge!(values)
      end
    end

    private

    def valid_time?(time)
      @state[:time] > time ? false : true
    end
  end
end