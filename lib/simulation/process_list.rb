module Simulation
  class ProcessList

  	def initialize
  		@_list = []
  		@_last_id = 0
  	end

  	def add(process)
			@_list << Process.new(@_last_id, process)
      @_last_id += 1
  	end

  	def remove(process)
      @_list.delete_if { |el| el.id == process.id }
    end

    def add_all(processes)
      processes.each do |p|
        add(p)
      end
    end

    def remove_all(processes)
      processes.each do |p|
        remove(p)
      end
    end

    def empty?
      @_list.empty?
    end
  end
end