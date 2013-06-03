module Statistics
  class BaseStatistic < Array
    def initialize(*args)
      super
      extend DescriptiveStatistics
    end
  end
end