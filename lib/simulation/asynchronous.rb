require 'celluloid'

module Simulation
  module Asynchronous

    def self.extended(base)
      define_method(:method_added) do |*args|
        if args[0].to_s == "run" and not base.included_modules.member? Celluloid
          include Celluloid
          define_asynchronous_method(base, :run)
        end
      end
    end
  
    def define_asynchronous_method(base, method)
      base.__send__(:alias_method, "#{method}_synchronous".to_sym, method)
      remove_method method
      base.class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{method}(*args)
          if args.empty?
            future.#{method}_synchronous
          else
            future.#{method}_synchronous(args)
          end
        end
      METHOD
    end
  end
end

class A
  extend Simulation::Asynchronous

  def run
    sleep 2
    return 15
  end
end

b = A.new
#=> #<Celluloid::ActorProxy(A:0x89678c)> 
f = b.run
#=> #<Celluloid::Future:0x00000001152e98>
f.value
#=> 15