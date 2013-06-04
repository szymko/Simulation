require File.join(File.dirname(__FILE__), '../test_helper')

class SystemTest < Minitest::Unit::TestCase

  def setup
    state = { customers: 12, shop: :open }
    @system = Simulation::System.new(state)
  end

  def test_it_updates
    new_state = { customers: 13, shop: :closed }
    newer_state = { customers: 14, shop: :opened, dogs: 3 }
    newer_system = Simulation::System.new(newer_state)

    @system.update(new_state)
    assert_equal new_state.merge(time: 0), @system.state

    @system.update(newer_system)
    assert_equal newer_system.state, @system.state
  end

  def test_it_does_not_accept_invalid_time
    new_state = { time: -1 }

    assert_raises(Simulation::InvalidTimeError) do
      @system.update(new_state)
    end
  end
end