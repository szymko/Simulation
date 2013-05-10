module Simulation  
  Activity = Struct.new(:id, :actv) do
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
  end
end