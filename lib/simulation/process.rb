require 'set'
require 'thread'

module Simulation  
  class Process < BaseProcess

    class InvalidStateError < StandardError; end

    attr_accessor :priority, :system
    attr_reader :state, :reactivation_time, :id

    STATES = Set.new(%w{Active Idle}).freeze

    @@ids = []

    # Ensure uniqueness of ids.
    def initialize
      @id = select_unique_id
      @@ids << @id

      super
    end

    # Pass the information about the surrounding system
    # to the process. Must be invoked before the simulation
    # begins.
    def setup(system)
      @system = system
    end

    def update_system(new_state)
      @system.update(new_state)
    end

    # Sets reactivation time, with validation.
    def reactivation_time=(value)
      if value >= 0 and value >= @reactivation_time.to_f
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

    def valid_id?(value)
      if value.is_a? Integer and value >= 0
        true
      else
        false
      end
    end

    alias :update :update_system

    def select_unique_id
      if @@ids.empty?
        0
      else
        @@ids.last + 1
      end
    end
  end
end