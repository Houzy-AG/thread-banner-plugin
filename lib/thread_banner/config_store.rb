# frozen_string_literal: true

module ::ThreadBanner
  module ConfigStore
    CONFIG_KEY = "config"

    module_function

    # Pure read -- never writes. (Self-healing the stored value here would mean
    # a database write on every GET, including anonymous topic-page requests.)
    def read
      normalize(PluginStore.get(STORE_NAMESPACE, CONFIG_KEY))
    end

    def write(banners)
      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, banners)
    end

    # Accepts the value stored by any past version of the plugin -- a plain
    # array, a JSON string, or a hash wrapping the array under a "config" key
    # -- and always returns a plain array.
    def normalize(data)
      return [] if data.blank?

      data = JSON.parse(data) if data.is_a?(String)
      data = data["config"] if data.is_a?(Hash)

      data.is_a?(Array) ? data : []
    rescue JSON::ParserError
      []
    end
  end
end
