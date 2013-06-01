require 'set'

module Simulation  
  class Process
    class InvalidStateError < StandardError; end
    class InvalidTimeError < StandardError; end
    class InvalidIdError < StandardError; end

    attr_accessor :id, :gatherer, :priority
    attr_reader :state, :reactivation_time

    STATES = Set.new(%w{Active Idle}).freeze

    def reactivation_time=(value)
      @time >= 0 ? @reactivation_time = value : raise InvalidTimeError
    end

    def state=(value)
      STATES.member?(value) ? @state = value : raise InvalidStateError
    end

    def id=(value)
      value.is_a? Integer and value > 0 ? @id = id : raise InvalidIdError
    end

    def active?
      @state == "Active"
    end

    def idle?
      @state == "Idle"
    end

    # decides whether the process can be run concurently
    def concurrent?
      false
    end
  end
end