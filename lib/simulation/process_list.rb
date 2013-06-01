module Simulation
  class ProcessList

    def initialize(processes = [])
      @_last_id = 0
      @_list = []
      add(processes)
    end

    def add(process_or_processes)
      if process_or_processes.is_a? Array
        add_all(process_or_processes)
      else
        add_one(process_or_processes)
      end
    end

    def add_all(processes)
      processes.each do |p|
        add_one(p)
      end
      self
    end

    def add_one(process)
      @_list << process
      process.id = @_last_id
      @_last_id += 1
      self
    end

    def remove(process_or_processes)
      if process_or_processes.is_a? Array
        remove_all(process_or_processes)
      else
        remove_one(process_or_processes)
      end
    end

    def remove_one(process)
      @_list.delete_if { |el| el.id == process.id }
      self
    end

    def remove_all(processes)
      processes.each { |p| remove_one(p) }
      self
    end

    def empty?
      @_list.empty?
    end

    def active
      active_processes = @_list.select { |l| l.active? }
      ProcessList.new(active_processes)
    end

    def idle
      idle_processes = @_list.select { |l| l.idle? }
      ProcessList.new(idle_processes)
    end

    def concurrent
      concurrent_processes = @_list.select { |l| l.concurrent? }
      ProcessList.new(concurrent_processes)
    end

    def single_thread
      single_thread = @_list.select { |l| not l.concurrent? }
      ProcessList.new(single_thread)
    end

    def sort_priority
      sorted_processes = @_list.sort { |a, b| a.priority <=> b.priority }
      ProcessList.new(sorted_processes)
    end

    def each
      @_list.each { |l| yield l }
    end
  end
end