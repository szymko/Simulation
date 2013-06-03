module Simulation  
  class CurrentList < ProcessList

    # Runs the processes concurrently in their
    # attached threads.
    def run
      active.execute_concurrently(:run)
    end

    # Decides, which of the processes should be moved away
    # from the current_list(checks reactivation time).
    def run_in_future(time_now)
      for_react = @_list.select { |p| r.reactivation_time >= time_now }
      remove(for_react)
      for_react
    end
  end
end