require File.join(File.dirname(__FILE__), '../test_helper')

class TestBaseProcess < Minitest::Unit::TestCase

  def setup
    @base_proc = Simulation::BaseProcess.new
    @sub = TestHelper::BaseProcessSub.new
  end

  def test_it_starts_new_thread
    @base_proc.start
    assert_equal true, @base_proc.thr.alive?
  end

  def test_it_can_invoke_methods_inside_threads
    @sub = TestHelper::BaseProcessSub.new
    @sub.start

    @sub.send_call(:say, "hello!")

    assert_equal "Saying hello!", @sub.get_response
    @sub.stop
  end

  def test_it_can_change_itself_from_internal_thread
    @sub.start

    @sub.send_call(:change)
    # It ensures thread will have time to change
    # the value of @sub.a
    @sub.get_response
    assert_equal 1, @sub.a

    @sub.stop
  end
end