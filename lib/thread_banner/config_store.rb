# frozen_string_literal: true

module ::ThreadBanner
  module ConfigStore
    CONFIG_KEY = "config"

    module_function

    def read
      normalize(PluginStore.get(STORE_NAMESPACE, CONFIG_KEY))
    end

    def write(banners)
      list = normalize(banners)
      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, list)
      list
    end

    # Accepts the value stored by any past version of the plugin -- a plain
    # array, a JSON string, or a hash wrapping the array under a "config" key
    # -- and always returns a plain array.
    def normalize(data)
      return [] if data.blank?

      data = JSON.parse(data) if data.is_a?(String)

      if data.is_a?(Hash)
        data = data["config"] || data[:config] || data["banners"] || data[:banners]
      end

      data.is_a?(Array) ? data : []
    rescue JSON::ParserError
      []
    end

    # Rewrites legacy PluginStore shapes to a plain array, but never overwrites
    # with an empty list (avoids repeating the v0.2.0 data-loss bug).
    def repair_storage!
      raw = PluginStore.get(STORE_NAMESPACE, CONFIG_KEY)
      banners = normalize(raw)
      return banners if banners.blank?
      return banners if raw.is_a?(Array)

      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, banners)
      banners
    end
  end
end
