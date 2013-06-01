module Simulation  
  class CurrentList < ProcessList

    def initialize
      super
    end

    def run(system)
      run_single_thread(system)
      run_concurrent(system)
    end

    def run_concurrent(system)
      threads = []
      mutex = Mutex.new

      active.concurrent.each do |p|
        threads << Thread.new do
          sys = p.run(system)

          mutex.synchronize do
            system.update(sys)
          end
        end
      end

    ensure
      threads.map! { &:join }
    end

    def run_single_thread(system)
      active.single_thread.each do |p|
        sys = p.run(system)
        system.update(sys)
      end
    end

    def for_reactivation(time_now)
      for_react = @_list.select { |p| r.reactivation_time >= time_now }
      remove(for_react)
      for_react
    end
  end
end