module WisperNext

  # Extension to provide objects with subscription and publishing capabilties
  #
  # @example
  #
  # class PromoteUser
  #   include Wisper.publisher
  #
  #   def call
  #     # ...
  #     broadcast(:user_promoted, user_id: user.id, ts: Time.now)
  #   end
  # end
  #
  # class NotifyUserOfPromotion
  #   def on_event(name, payload)
  #     puts "#{name} => #{payload.inspect}"
  #   end
  # end
  #
  # command = PromoteUser.new
  # command.subscribe(NotifyUserOfPromotion.new)
  # command.call
  #
  class Publisher < Module
    def included(descendant)
      super
      descendant.send(:include, Methods)
    end

    # Exception raised when a listener is already subscribed
    #
    # @api public
    #
    ListenerAlreadyRegisteredError = Class.new(StandardError) do
      # @api private
      def initialize(listener)
        super("listener #{listener.inspect} is already subscribed")
      end
    end

    # Exception raised when a listener is not subscribed
    #
    # @api public
    #
    ListenerNotRegisteredError = Class.new(StandardError) do
      # @api private
      def initialize(listener)
        super("listener #{listener.inspect} is not subscribed")
      end
    end

    # Exception raised when a listener does not have an #on_event method
    #
    # @api public
    #
    NoEventHandlerError = Class.new(ArgumentError) do
      # @api private
      def initialize(listener)
        super("listener #{listener.inspect} does not have an #on_event method")
      end
    end

    module Methods
      # returns true when given listener is already subscribed
      #
      # @param [Object] listener
      #
      # @return [Boolean]
      #
      # @api public
      #
      def subscribed?(listener)
        subscribers.include?(listener)
      end

      # subscribes given listener
      #
      # @param [Object] listener
      #
      # @return [Object] self
      #
      # @api public
      #
      def subscribe(listener)
        raise ListenerAlreadyRegisteredError.new(listener) if subscribed?(listener)
        raise NoEventHandlerError.new(listener) unless listener.respond_to?(:on_event)
        subscribers.push(listener)
        self
      end

      # unsubscribes given listener
      #
      # @param [Object] listener
      #
      # @return [Object] self
      #
      # @api public
      #
      def unsubscribe(listener)
        raise ListenerNotRegisteredError.new(listener) unless subscribed?(listener)
        subscribers.delete(listener)
        self
      end

      # unsubscribes all listeners
      #
      # @return [Object] self
      #
      # @api public
      #
      def unsubscribe_all
        subscribers.clear
        self
      end

      # subscribes the given block to an event
      #
      # @param [String, Symbol] event name
      #
      # @return [Object] self
      #
      # @api public
      #
      def on(name, &block)
        raise ArgumentError, 'must pass a block' unless block_given?
        subscribe(CallableAdapter.new(name, block))
        self
      end

      private

      # Broadcast event to all subscribed listeners
      #
      # @param [String,Symbol] event name
      #
      # @param [Object] optional payload
      #
      # @return [Object] self
      #
      # @api public
      #
      def broadcast(name, payload = nil)
        subscribers.dup.each do |s|
          s.public_send(:on_event, name, payload)
        end

        self
      end

      # Returns subscribed listeners
      #
      # @return [Array<Object>] collection of subscribers
      #
      # @api private
      #
      def subscribers
        @subscribers ||= []
      end
    end
  end
end

require_relative 'publisher/callable_adapter'
