module Statistics
  # Subclass of an Array. Extends
  # DescriptiveStatistics without polluting
  # global namespace.
  class BaseStatistic < Array
    def initialize(*args)
      super
      extend DescriptiveStatistics
    end
  end
end