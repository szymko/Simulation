module Simulation
  # ProcessList contains all the methods
  # common for both current and future lists.
  # It provides also possibility to make it easier
  # to perform concurrent execution of the processes from the list.
  #
  # Some of the methods are chainable, e.g.
  # p = ProcessList.new(procs); p.active.execute_concurrently(:touch)
  class ProcessList

    def initialize(processes = [])
      @_list = []
      add(processes)
    end

    # Add one process, or provide more
    # processes using an Array.
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
      active_ids = extract_ids(active_collection, true)

      active_processes = @_list.select { |l| active_ids.member?(l.id)}
      ProcessList.new(active_processes)
    end

    def idle
      idle_collection = execute_concurrently(:idle?)
      idle_ids = extract_ids(idle_collection, true)

      idle_processes = @_list.select { |l| idle_ids.member?(l.id)}
      ProcessList.new(idle_processes)
    end

    # Sort by Process attribute. It is not beutiful and maybe it
    # should be deleted at all.
    def sort_by(attribute)
      sorted_processes = @_list.sort { |a, b| a.send(attribute) <=> b.send(attribute) }
      ProcessList.new(sorted_processes)
    end

    # fetch each process
    def each
      @_list.each { |l| yield l }
    end

    # Send instructions to all processes on the list
    # and wait for them to return some value.
    # It will block the execution stream,
    # but it is faster, since each process usees a seperate Thread.
    #
    # Arguments should be an array.
    # In response there is returned an array, which members
    # are two - element arrays containing Process#id and 
    # method execution result. 
    def execute_concurrently(method, *arguments)
      response_array = []

      @_list.each do |p|
        p.start if p.thr.nil?

        p.send_call(method, *arguments)
      end

      @_list.each { |p| response_array << [p.id, p.get_response] }

      response_array
    end

    alias :each_process :each

    private

    # After concurrent execution find Process#ids for processes, which
    # returned given value.
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