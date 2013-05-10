module Simulation  
  class ActiveList < ActivityList

    def execute_all
      sort_by_priority
      execute_and_drop
    end

    def get_list
      { active: @_list }
    end

    private

    def sort_by_priority
      return nil if @_list.nil?
      @_list.sort! { |a, b| a.priority <=> b.priority }
    end

    def execute_and_drop
      @_list.each do |a|
        a.execute
      end

      @_list = []
    end
  end
end