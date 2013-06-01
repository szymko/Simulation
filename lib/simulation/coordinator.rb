module Simulation  
  class Coordinator

    attr_accessor :time, :current_list, :future_list, :system

    def initialize(system = {})
      @time = 0
      @current_list = CurrentList.new
      @future_list = FutureList.new
      @system = system
    end

    def add_process(process_or_processes)
      @future_list.add(process_or_processes)
    end

    def step
      move_ready
      @current_list.run(@system)
      move_to_reactivation
    end

    def move_ready
      ready = @future.ready_for_reactivation
      @time = ready.first.reactivation_time
      @current_list.add(ready)
    end

    def move_to_reactivation
      for_react = @current_list.for_reactivation(@time)
      @future_list.add(for_react)
    end
  end
end