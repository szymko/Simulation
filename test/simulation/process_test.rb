require File.join(File.dirname(__FILE__), '../test_helper')

class TestProcess < Minitest::Unit::TestCase

  def setup
    @process = Simulation::Process.new
    @mocked_system = Minitest::Mock.new
  end

  def test_it_can_update_system
    @process.setup(@mocked_system)

    new_state =  { attr1: 15, attr2: 1 }
    @mocked_system.expect(:update, new_state, [Hash])

    @process.update(new_state)
    @mocked_system.verify
  end

  def test_it_raises_error_for_negative_time_value
    negative_time = -1

    assert_raises(Simulation::InvalidTimeError) do
      @process.reactivation_time = negative_time
    end
  end

  def test_it_raises_error_for_time_value_in_past
    @process.reactivation_time = 10
    time_in_past = 8

    assert_raises(Simulation::InvalidTimeError) do
      @process.reactivation_time = time_in_past
    end
  end

  def test_it_raises_error_for_invalid_state
    invalid_state = "Busy"

    assert_raises(Simulation::Process::InvalidStateError) do
      @process.state = invalid_state
    end
  end

  def test_it_keeps_unique_id_for_subclasses
    sub_p = TestHelper::ProcessSub.new
    assert_equal TestHelper::ProcessSub.class_variable_get(:@@ids), Simulation::Process.class_variable_get(:@@ids)
  end
end