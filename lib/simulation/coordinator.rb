module Simulation  
  class Coordinator

  	def initialize(environment = {})
  		@waiting_list = WaitingList.new
  		@active_list = ActiveList.new
  		@time = 0
      @environment = environment
  	end

  	def add_to_waiting_list(activity)
  		@waiting_list.add(activity)
  	end

    def step
      clean_waiting_list
      update_time

      move_to_active_list
      execute_active_list
    end

    def get_snapshot
      { waiting: @waiting_list.get_list, active: @active_list.get_list, 
        time: @time, environment: @environment }
    end

    def empty_waiting_list?
      @waiting_list.empty?
    end

    private
  	
    def move_to_active_list
      to_be_executed = @waiting_list.select do |list|
        list.select { |el| el.start_time == @time and el.header_conditions_fulfilled?(@environment) }
      end

      @active_list.add_all(to_be_executed)
    end

    def update_time(list)
      ready_for_execution = list.select { |el| el.header_conditions_fulfilled?(@environment) }

      ready_for_execution.sort! { |a, b| a.start_time <=> b.start_time }
      @time = ready_for_execution.first.start_time
    end

    def clean_waiting_list
      @waiting_list.disable_never_active { |el| el.start_time < @time }
    end

    def execute_active_list
      @active_list.execute_all
    end
  end
end