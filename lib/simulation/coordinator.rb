require 'forwardable'

module Simulation
  # Coordinator plays major role in simulation.
  #
  # It controls the flow of the processes, places them in the appropriate
  # queues, runs them adjusts the clock.
  # It is also capable of stopping the simulation.
  class Coordinator

    extend Forwardable

    attr_accessor :time, :current_list, :future_list, :system, :max_time

    def initialize(system = {})
      @current_list = CurrentList.new
      @future_list = FutureList.new
      @system = system
    end

    # It alway starts from the @process[:time] = 0 and
    # adjusts the clock according to the processes on the
    # future list.
    def start
      @system.update(time: 0)
      loop do
        if stopping_criteria?
          stop
          break
        end
        step
      end
    end

    # Delegates adding the processes to the coordinator.
    # User is able to add them in this way only to the
    # @future_list, as the coordinator is smart enough to pick
    # the nearest in time by itself.
    #
    # Adding processes, which are in the past will raise an error.
    def_delegator :@future_list, :add, :add_process

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

    def stopping_criteria?
      list_criterion = @future_list.empty? and @current_list.active.empty?
      if @max_time
        time_criterion = @system[:time] > @max_time ? true : false
        list_criterion or time_criterion
      end
      list_criterion
    end

    private

    # Move the processes beetween two queues:
    # - queue of the future events(@future_queue),
    # - queue of the current events, which may, or may not,
    #   be active(@current_queue).
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