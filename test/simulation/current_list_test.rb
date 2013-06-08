require File.join(File.dirname(__FILE__), '../test_helper')

class TestCurrentList < Minitest::Unit::TestCase

  include TestHelper

  def setup
    @processes = [ ProcessSub.new, ProcessSub.new ]
    @long_running = [ LongProcess.new, LongProcess.new ]
    @current_list = Simulation::CurrentList.new
  end

  def test_it_runs_processes
    @current_list.add(@processes)
    @processes.each { |p| p.state = "Active" }
    expected = Array.new(2) { @processes.first.run }

    assert_equal_process_return_values expected, @current_list.run
  end

  def test_it_runs_processes_concurrently
    @long_running.each { |p| p.state = "Active" }
    @current_list.add(@long_running)
    returned = []

    long_running_list = @current_list.instance_variable_get(:@_list)
    expected = Array.new(2) { @processes.first.run }
    exec_time = Benchmark.realtime { returned = @current_list.run }

    assert_in_epsilon(1, exec_time, 0.2)
    assert_equal_process_return_values(expected, returned)
  end

  def test_it_selects_processes_reactivating_in_future
    @processes[0].reactivation_time = 12
    @processes[1].reactivation_time = 11
    time_now = 11

    @current_list.add(@processes)
    assert_equal @processes[0], @current_list.run_in_future(time_now).first
  end
end