require File.join(File.dirname(__FILE__), '../test_helper')

class TestCollector < MiniTest::Unit::TestCase

  include TestHelper

  def test_it_collects_data
    s = StubForCollector.new
    result_ary = []
    4.times { result_ary << s.random }

    assert_equal result_ary, s.random_invocation_stats
  end

end