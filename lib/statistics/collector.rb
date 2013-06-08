module Statistics
  module Collector

    # Collects the return values of each of the methods.
    # Remembers each method call. The history of calls
    # can be accessed by calling #{method}_invocation_stats.
    def collect_on(*methods)

      methods.each do |method|
        system_states = []
        old_method = instance_method(method)

        define_method(method) do |*args|
          system_states << old_method.bind(self).call(*args)
          system_states.last
        end

        define_method("#{method}_invocation_stats".to_sym) do
          system_states
        end
      end
    end

    # Extracts statistics of one element of a system and
    # return a BaseStatistic instance build upon them.
    # Intended to provide a handy way to illustrate changes
    # of attributes of the system.
    # element_statistics(stats, :pool_queue)
    # #=> [1,2, ... 12, 1, 0]
    def self.create_element_stat(system_stats, element)
      stats_ary = system_stats.map(&:to_a).flatten(1)
      element_stats = stats_ary.select { |e| e.first == element }

      element_stats.flatten!.delete_if { |el| el.is_a? Symbol }
      element_stats = BaseStatistic.new(element_stats)
    end

    # Creates timeseries, which reflects changing values
    # over time.
    def self.create_timeseries(system_stats, element)
      data = create_element_stat(system_stats, element)
      time = create_element_stat(system_stats, :time)

      TimeSeries.new(time, data)
    end
  end
end