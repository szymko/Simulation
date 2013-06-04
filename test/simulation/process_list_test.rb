require File.join(File.dirname(__FILE__), '../test_helper')

class TestProcessList < Minitest::Unit::TestCase

  include TestHelper

  def setup
    @process_list = Simulation::ProcessList.new
    @p1 = Simulation::Process.new
    @p2 = Simulation::Process.new
    @p3 = Simulation::Process.new
  end

  def test_it_adds_sinle_process_to_list
    @process_list.add(@p1)
    assert_equal_process_list [@p1], @process_list
  end

  def test_it_adds_multiple_processes_at_once
    @process_list.add([@p2, @p3])
    assert_equal_process_list [@p2, @p3], @process_list
  end

  def test_it_removes_given_processes
    @process_list.add([@p1, @p2, @p3])
    @process_list.remove([@p1, @p3])

    assert_equal_process_list [@p2], @process_list
  end

  def test_it_selects_active_and_idle_processes
    @p1.state = "Active"
    @p3.state = "Active"
    @process_list.add([@p1, @p2, @p3])

    assert_equal_process_list [@p1, @p3], @process_list.active
  end

  def test_it_selects_idle_processes
    @p1.state = "Active"
    @p3.state = "Active"
    @process_list.add([@p1, @p2, @p3])

    assert_equal_process_list [@p2], @process_list.idle
  end
end