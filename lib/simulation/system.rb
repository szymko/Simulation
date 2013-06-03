module Simulation
  class System

    def initialize(system = {})
      @state = system
      @state[:time] ||= 0
    end

    def update(new_state)
      @state.merge!(new_state)
    end
  end
end