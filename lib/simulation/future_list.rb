module Simulation  
  class FutureList < ProcessList

    def initialize
      @_never_active_list = []
      super
    end

    def select
      to_be_executed = yield(@_list)
      @_list.remove_all(to_be_executed)

      to_be_executed
    end

    def get_list
      { waiting_list: @_list, never_active_list: @_never_active_list}
    end

    def disable_never_active(picker)
      @_never_active_list, @_list = @_list.partition { |el| yield(el) }
    end
  end
end