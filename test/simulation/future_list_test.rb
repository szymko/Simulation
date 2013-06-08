require File.join(File.dirname(__FILE__), '../test_helper')

class TestFutureList < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @processes = [ ProcessSub.new, ProcessSub.new ]
    @future_list = Simulation::FutureList.new
  end

  def test_it_selects_processes_reactivating_now
    @processes[0].reactivation_time = 11
    @processes[1].reactivation_time = 1

    @future_list.add(@processes)
    assert_equal @processes[1], @future_list.reactivate_now.first
  end
end