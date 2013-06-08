require 'minitest/spec'
require 'minitest/autorun'
require 'benchmark'
require File.join(File.dirname(__FILE__), '../lib/simulation')

module TestHelper
  class BaseProcessSub < Simulation::BaseProcess
    attr_accessor :a

    def say(word)
      "Saying #{word}"
    end

    def change
      @a = 1
    end
  end

  class ProcessSub < Simulation::Process
    def run
      "Hello, punk!"
    end
  end

  class LongProcess < Simulation::Process
    def run
      sleep 1
      "Hello, punk!"
    end
  end

  class StateChangingProcess < Simulation::Process
    def initialize
      @counter = 0
      super
    end

    def run
      @counter += 1
      @state = "Idle" if @counter == 2
      "Hello, punk!"
    end
  end

  class StubForCollector

    extend Statistics::Collector

    def random
      # ~chosen by fair dice roll
      # see: http://xkcd.com/221/
      4
    end

    collect_on(:random)
  end

  def assert_equal_process_list(expected_list, process_list)
    list = process_list.instance_variable_get(:@_list)
    assert_equal(expected_list, list)
  end

  def assert_equal_process_return_values(expected, returned)
    values = returned.map { |m| m[1] }
    assert_equal expected, values
  end
end