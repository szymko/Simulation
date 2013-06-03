module Statistics
  class TimeSeries
    class InvalidTimeError < StandardError; end
    class MismatchedDataError < StandardError; end

    attr_accessor :data, :time

    def initialize(*args)
      build(args)
    end

    # build from hash, where keys represent time
    # and values data associated with it
    def build(*data)
      if data.length == 1
        build_from_single(*data)
      elsif data.count.even?
        build_from_multiple(*args)
      else
        raise MismatchedDataError
      end
    end

    def valid_time?(value, previous = -1)
      numeric = if value.is_a? Numeric and value > 0
                  true
                else
                  false
                end
      ascending = value > previous

      numeric and ascending
    end

    def build_from_multiple(data_arys)
      @time ||= []
      @data ||= BasicStatistic.new
      data_arys.each_slice(2) do |time, data|
        raise MismatchedDataError unless time.length == data.length

        time.each do |t|
          if valid_time?(t, @time.last)
            @time << t
          else
            raise InvalidTimeError
          end
        end

        @data += data
      end
    end

    def build_from_single(data_ary)
      @time ||= []
      @data ||= BasicStatistic.new
      data_ary.each_with_index do |d, idx|
        @time << idx
        @data << d
      end
    end
  end
end