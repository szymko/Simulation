module Simulation  
  class Coordinator

    attr_accessor :time, :current_list, :future_list, :system

    def initialize(system = {})
      @current_list = CurrentList.new
      @future_list = FutureList.new
      @system = system
    end

    def start
      @system.update(time: 0)
      loop do
        if stop_criteria?
          stop
          break
        end
        step
      end
    end

    def add_process(process_or_processes)
      @future_list.add(process_or_processes)
    end

    # sets up system in each process of future list
    # it is intended for use at the beginning of the simulation,
    # so the @current_list is not affected.
    def setup(system)
      @system = system
      @future_list.each { |p| p.setup(@system) }
    end

    def step
      move_to_current
      @current_list.run
      move_to_future
    end

    private

    def move_to_current
      current = @future_list.run_now
      current_time = current.first.reactivation_time

      @system.update(time: current_time)
      @current_list.add(current)
    end

    def move_to_future
      in_future = @current_list.run_in_future(@time)
      @future_list.add(in_future)
    end
  end
end