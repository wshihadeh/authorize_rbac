module AuthorizeRbac
  class Configuration

    CONFIG_KEYS = [
     :current_user_method,
     :default_controller,
     :default_action
    ]

    def initialize
      @configs = {}
    end

    def []=(key, value)
      raise InvalidKey, key unless CONFIG_KEYS.include?(key)

      @configs[key] = value
    end

    def [](key)
      @configs[key]
    end

    CONFIG_KEYS.each do |config_key|
      define_method(config_key) do
        @configs[config_key]
      end
      define_method("#{config_key}=") do |value|
        @configs[config_key] = value
      end
    end

    class InvalidKey < StandardError
      def initialize(key)
        super("Configuration option '#{key.inspect}' is not a valid key")
      end
    end
  end
end
