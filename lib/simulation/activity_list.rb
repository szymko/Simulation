module Simulation
  class ActivityList

  	def initialize
  		@_list = []
  		@_last_id = 0
  	end

  	def add(activity)
			@_list << Activity.new(@_last_id, activity)
      @_last_id += 1
  	end

  	def remove(activity)
      @_list.delete_if { |el| el.id == activity.id }
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
  end
end