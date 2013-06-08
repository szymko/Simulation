require File.join(File.dirname(__FILE__), '../test_helper')

class TestTimeSeries < Minitest::Unit::TestCase

  def test_it_builds_time_series_from_single_array
    data_ary = [5, 10, 15, 20, 25]
    time_series = Statistics::TimeSeries.new(data_ary)

    assert_equal data_ary, time_series.data
    assert_equal [0, 1, 2, 3, 4], time_series.time
  end

  def test_it_builds_time_series_from_two_arrays
    time = [1, 14, 44, 123]
    data = [-16, 12, 14, -100]

    time_series = Statistics::TimeSeries.new(time, data)
    assert_equal time, time_series.time
    assert_equal data, time_series.data
  end

  def test_it_builds_time_series_from_multiple_arrays
    time_1 = [1, 2, 3]
    data_1 = [4, 5, 6]
    time_2 = [15, 16, 18]
    data_2 = [-1, -15, 4]

    time_series = Statistics::TimeSeries.new(time_1, data_1, time_2, data_2)
    assert_equal time_1 + time_2, time_series.time
    assert_equal data_1 + data_2, time_series.data
  end

  def test_it_raises_an_error_for_mismatched_data
    time_1 = [1, 2, 3]
    data_1 = [4, 5, 6, 7]
    time_2 = [15, 16, 18]
    data_2 = [-1, -15, 4]
    time_3 = [1, 2, 3]

    assert_raises(Statistics::TimeSeries::MismatchedDataError) do
      time_series = Statistics::TimeSeries.new(time_1, data_1)
    end

    assert_raises(Statistics::TimeSeries::MismatchedDataError) do
      time_series = Statistics::TimeSeries.new(time_2, data_2, time_3)
    end
  end

  def test_it_raises_an_error_for_wrong_time
    time = [1, 13, 7]
    data = [1, 1 ,1]

    assert_raises(Simulation::InvalidTimeError) do
      time_series = Statistics::TimeSeries.new(time, data)
    end
  end
end