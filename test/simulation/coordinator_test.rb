require File.join(File.dirname(__FILE__), '../test_helper')

class TestCoordinator < MiniTest::Unit::TestCase

  include TestHelper

  def setup
    @coordinator = Simulation::Coordinator.new
    @p1 = StateChangingProcess.new
    @p2 = StateChangingProcess.new
    @p1.reactivation_time = 1
    @p2.reactivation_time = 2
    @p1.state = "Active"
    @p2.state = "Active"

    @coordinator.add_process([@p1, @p2])
    @coordinator.setup
  end

  def test_it_does_a_step
    @coordinator.step
    assert_equal_process_list [@p1], @coordinator.current_list
    assert_equal_process_list [@p2], @coordinator.future_list
  end

  def test_it_runs_until_future_list_empty
    @coordinator.start
    assert_equal 2, @coordinator.time
  end
end