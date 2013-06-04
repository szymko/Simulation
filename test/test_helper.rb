require 'minitest/spec'
require 'minitest/autorun'
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
  end

  def assert_equal_process_list(expected_list, process_list)
    list = process_list.instance_variable_get(:@_list)
    assert_equal(expected_list, list)
  end
end