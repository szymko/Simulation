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

    def remove(process_or_processes)
      if process_or_processes.is_a? Array
        remove_all(process_or_processes)
      else
        remove_one(process_or_processes)
      end
    end

    def empty?
      @_list.empty?
    end

    def active
      active_collection = execute_concurrently(:active?)
      active_ids = extract_ids(active_collection, :true)

      active_processes = @_list.select { |l| active_ids.member?(l.id)}
      ProcessList.new(active_processes)
    end

    def idle
      idle_collection = execute_concurrently(:idle?)
      idle_ids = extract_ids(idle_collection, :true)

      idle_processes = @_list.select { |l| idle_ids.member?(l.id)}
      ProcessList.new(idle_processes)
    end

    def sort_by(attribute)
      sorted_processes = @_list.sort { |a, b| a.send(attribute) <=> b.send(attribute) }
      ProcessList.new(sorted_processes)
    end

    def each
      @_list.each { |l| yield l }
    end

    def execute_concurrently(method, arguments)
      response_array = []

      @_list.each do |p|
        p.in_queue << method
        p.in_queue << arguments
      end

      @_list.each { |p| response_array << [p.id, p.out_queue.pop] }

      response_array
    end

    private

    def extract_ids(responses, value)
      positive_ids = responses.map{ |l| l[0] if l[1] == value }.compact
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

    def remove_one(process)
      @_list.delete_if { |el| el.id == process.id }
      self
    end

    def remove_all(processes)
      processes.each { |p| remove_one(p) }
      self
    end
  end
end