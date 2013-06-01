module Simulation  
  class FutureList < ProcessList

    def initialize
      super
    end      

    def ready_for_reactivation
      @_list.sort! { |p1, p2| p1.reactivation_time <=> p2.reactivation_time }
      time_now = @_list.first.reactivation_time
      ready = @_list.select { |p| r.reactivation_time == time_now }
      
      remove(ready)
      ready
    end
  end
end