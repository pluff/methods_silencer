module MethodsSilencer
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def silent_methods(methods, exceptions = [Exception])
      [methods].flatten.each do |method|
        if self.instance_methods.include?(:"#{method}!")
          define_method(method.to_sym) do |*args|
            begin
              send(:"#{method}!", *args)
            rescue *([exceptions].flatten) => e
              yield(e) if block_given?
              nil
            end
          end
        end
      end
    end
  end
end
