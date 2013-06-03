require 'set'
require 'thread'

module Simulation  
  class Process < BaseProcess

    class InvalidStateError < StandardError; end
    class InvalidIdError < StandardError; end

    attr_accessor :id, :priority, :system
    attr_reader :state, :reactivation_time

    STATES = Set.new(%w{Active Idle}).freeze

    # Pass the information about the surrounding system
    # to the process. Must be invoked before the simulation
    # begins.
    def setup(system)
      @system = system
    end

    # Sets reactivation time, with validation.
    def reactivation_time=(value)
      if @time >= 0
        @reactivation_time = value
      else
        raise InvalidTimeError
      end
    end

    # Allows only states contained in STATES.
    def state=(value)
      if STATES.member?(value)
        @state = value
      else
        raise InvalidStateError
      end
    end

    def id=(value)
      if value.is_a? Integer and value > 0
        @id = id
      else
        raise InvalidIdError
      end
    end

    def active?
      @state == "Active"
    end

    def idle?
      not active?
    end

    # Decides whether the process can be run concurrently.
    def concurrent?
      true
    end
  end
end