module Simulation  
  class CurrentList < ProcessList

    def initialize
      super
    end

    def run
      active.execute_concurrently(:run)
    end

    def run_in_future(time_now)
      for_react = @_list.select { |p| r.reactivation_time >= time_now }
      remove(for_react)
      for_react
    end
  end
end