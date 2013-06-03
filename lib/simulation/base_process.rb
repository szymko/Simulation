require 'thread'

module Simulation

  # Provides base for the process functionality.
  # Mainly deals with starting up a new thread for each
  # instance with BaseProcess#start.
  # Sends the methods to the thread via @in_queue,
  # the results can be obtained by calling @out_queue.pop.
  # 
  # It is important to note that the methods sent to the 
  # process may execute concurrently, but calling Queue#pop
  # will make the current process stop and wait for the result to come.
  # e.g. 

  # b = BaseProcess.new
  # b.in_queue << :long_executing_method; b.in_queue << [arg1, arg2, ...]
  # 
  # b.out_queue.pop
  # => waits for the long_executing_method to return
  class BaseProcess

    attr_accessor :in_queue, :out_queue, :thr, :system_changing

    # @system_changing - array of names of the methods, which
    # should change the state of the system.
    # They should return new system object, or hash to merge with the old
    # one. If enable_synchronization is set, each modification to system is done 
    # with the mutex.
    def initialize
      @in_queue ||= Queue.new
      @out_queue ||= Queue.new
      @system_changing = [:run]
    end


    def enable_synchronization(semaphore)
      @system_semaphore = semaphore
    end

    def start
      @thr ||= Thread.new do
        loop do
          # create Method instance from a method name
          meth = method(@in_queue.pop)

          # Method#arity returns the number of arguments
          if meth.arity == 0
            args = []
          else
            args = @in_queue.pop
          end

          @out_queue.push(call_from_queue(meth, args))
        end
      end
    end

    def destroy
      @thr.join unless @thr.nil?
    end

    private

    def change_system_state(new_state)
      if @system_semaphore
        @system_semaphore.synchronize { @system.update(new_state) }
      else
        @system.update(new_state)
      end
    end

    def call_from_queue(meth, args)
      return_value = meth.call(*args)
      change_system_state(return_value) if system_changing.member?(meth.name)
      
      return_value
    end
  end
end