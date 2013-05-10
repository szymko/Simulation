module Simulation
  class ActivityList

  	def initialize
  		@_list = []
  		@_last_id = 0
  	end

  	def add(activity)
  		if is_valid_activity?(activity)
  			@_list << Activity.new(@_last_id, activity)
        @_last_id += 1
  		else
  			raise ArgumentError, 'Given activity is not valid (check if it responds to all required methods).'
  		end
  	end

  	def remove(activity)
      if is_valid_activity?(activity)
        @_list.delete_if { |el| el.id == activity.id }
      else
        raise ArgumentError, 'Given activity is not valid (check if it responds to all required methods).'
      end
    end

    def add_all(activities)
      activities.each do |a|
        add(a)
      end
    end

    def remove_all(activities)
      activities.each do |a|
        remove(a)
      end
    end

    def empty?
      @_list.empty?
    end

  	private

  	def is_valid_activity?(activity)
  		if activity.respond_to?(:start_time) and activity.respond_to?(:priority)
        and activity.respond_to?(:header_conditions_fulfilled?) and activity.respond_to?(:execute)
        
  			return true
  		else
  			return false
  		end
  	end
  end
end