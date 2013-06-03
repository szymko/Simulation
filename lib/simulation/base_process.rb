require 'thread'

module Simulation
  class BaseProcess

    attr_accessor :in_queue, :out_queue, :thr, :system_changing

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
          meth = method(@in_queue.pop)

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