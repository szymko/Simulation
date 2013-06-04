require 'monitor'

module Simulation
  class System

    include MonitorMixin

    attr_accessor :state

    # Call to super seems to be required by MonitorMixin
    # (crashes without it).
    def initialize(system = {})
      @state = system
      @state[:time] ||= 0
      super()
    end

    # Enables updating the chosen components of the system
    # in the way similar to Hash#merge!
    # 
    # Validates time. Should you need more validations
    # subclass Simulation::System and overwrite Simulation::System#merge
    # Remember to call super, otherwise the time will not be checked.
    #
    # Synchronization according to 
    # http://www.ruby-doc.org/stdlib-2.0/libdoc/monitor/rdoc/MonitorMixin.html#method-i-mon_synchronize
    def update(new_state)
      self.synchronize do
        if new_state.is_a? Simulation::System
          self.merge(new_state.state)
        else
          self.merge(new_state)
        end
      end
    end

    def merge(values)
      if values.has_key? :time
        merge_time(values)
      else
        @state.merge!(values)
      end
    end

    private

    def valid_time?(time)
      if @state[:time] <= time
        true
      else
        false
      end
    end

    def merge_time(values)
      if valid_time?(values[:time])
        @state.merge!(values)
      else
        raise InvalidTimeError
      end
    end
  end
end