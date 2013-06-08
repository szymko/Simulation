module Statistics
  class TimeSeries
    class MismatchedDataError < StandardError; end

    attr_accessor :data, :time

    def initialize(*args)
      build(args)
    end

    def build(data)
      if data.length == 1
        build_from_single(*data)
      elsif data.count.even?
        build_from_multiple(data)
      else
        raise MismatchedDataError
      end
    end

    # Does not allow time to be negative.
    # New value cannot also be lower than
    # previous given moment.
    def valid_time?(value, previous)
      numeric = if value.is_a? Numeric and value > 0
                  true
                else
                  false
                end
      ascending = previous.nil? ? true : value > previous

      numeric and ascending
    end

    # Build timeseries from multiple arrays.
    # When more than two arrays are given,
    # each following two are treated as the continuation
    # of the previous data stream.
    #
    # e.g.
    # ts = Statistics::TimeSeries.new([1,2], [3,4], [5,6], [-1,12])
    # ts.time
    # #=> [1,2,5,6]
    # ts.data
    # #=> [3,4,-1,12]
    def build_from_multiple(data_arys)
      @time ||= []
      @data ||= BaseStatistic.new
      data_arys.each_slice(2) do |time, data|
        raise MismatchedDataError unless time.length == data.length

        time.each do |t|
          if valid_time?(t, @time.last)
            @time << t
          else
            raise Simulation::InvalidTimeError
          end
        end

        @data += data
      end
    end

    def build_from_single(data_ary)
      @time ||= []
      @data ||= BaseStatistic.new
      data_ary.each_with_index do |d, idx|
        @time << idx
        @data << d
      end
    end
  end
end