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
    class NoMethodGivenError < StandardError; end

    attr_accessor :thr, :system_changing, :silenced_errors
    attr_reader :in_queue, :out_queue

    # @system_changing - array of names of the methods, which
    # should change the state of the system.
    # They should return new system object, or hash to merge with the old
    # one. If enable_synchronization is set, each modification to system is done 
    # with the mutex.
    def initialize
      @in_queue ||= Queue.new
      @out_queue ||= Queue.new
    end

    def start
      @thr ||= Thread.new do
        loop do
          bundle = @in_queue.pop
          # create Method instance from a method name
          meth = method(bundle[0])
          args = bundle[1]

          res = meth.call(*args)
          @out_queue.push(meth.call(*args))
        end
      end
    end

    def join
      @thr.join unless @thr.nil?
    end

    def kill
      @thr.kill unless @thr.nil?
    end

    alias :stop :kill

    def send_call(method, *args)
      @in_queue << [method, args]
      @waiting = true
    end

    def get_response
      if @waiting
        @waiting = false
        @out_queue.pop
      else
        raise NoMethodGivenError
      end
    end
  end
end