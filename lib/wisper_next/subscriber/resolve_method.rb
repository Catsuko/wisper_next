module WisperNext
  class Subscriber
    class ResolveMethod
      def self.call(name, prefix)
        name = name.underscore if name.respond_to?(:underscore)

        if prefix
          "on_#{name}"
        else
          name
        end
      end
    end
  end
end

