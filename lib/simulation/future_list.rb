module Simulation  
  class FutureList < ProcessList

    # Decides, which of the processes are ready
    # for reactivation and moves them away from the queue.
    def reactivate_now
      return [] if @_list.empty?

      @_list.sort! { |p1, p2| p1.reactivation_time <=> p2.reactivation_time }
      time_now = @_list.first.reactivation_time
      ready = @_list.select { |p| p.reactivation_time == time_now }
      
      remove(ready)
      ready
    end
  end
end