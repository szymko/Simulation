module Simulation  
  Activity = Struct.new(:id, :actv) do

    def initialize(id, activity)
      unless is_valid_activity?(activity) and id.is_a? Integer
        raise ArgumentError, 'At least one of the arguments is not valid.'
      end
        
      super
    end

  	def start_time
      return nil if @actv.nil?

   	  @actv.start_time
    end

  	def priority
      return nil if @actv.nil? 

      @actv.priority
    end

    def header_conditions_fulfilled?(*args)
      return nil if @actv.nil?

      @actv.header_conditions_fulfilled?(args)
    end

    def execute
      return nil if @actv.nil?

      @actv.execute
    end

    private

    def is_valid_activity?(activity)
      if activity.respond_to?(:start_time) and activity.respond_to?(:priority) and activity.respond_to?(:header_conditions_fulfilled?) and activity.respond_to?(:execute)
        
        return true
      else
        return false
      end
    end
  end
end