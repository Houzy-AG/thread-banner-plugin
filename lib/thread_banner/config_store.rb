# frozen_string_literal: true

module ::ThreadBanner
  module ConfigStore
    CONFIG_KEY = "config"

    module_function

    def read
      raw = PluginStore.get(STORE_NAMESPACE, CONFIG_KEY)
      banners = normalize(raw)
      persist_parsed_config(raw, banners)
      banners
    end

    def write(banners)
      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, banners)
    end

    def normalize(data)
      return [] if data.blank?

      data = JSON.parse(data) if data.is_a?(String)
      # Legacy versions of the plugin stored the banner array wrapped under a
      # "config" key (e.g. {"config" => [...]}). Unwrap it so callers always
      # receive a plain array.
      data = data["config"] if data.is_a?(Hash)

      data.is_a?(Array) ? data : []
    rescue JSON::ParserError
      []
    end

    # One-time self-healing migration: if the stored value was a legacy string
    # or wrapped hash, rewrite it as a plain array so later reads skip parsing.
    def persist_parsed_config(raw, banners)
      return unless banners.is_a?(Array)
      return if raw.is_a?(Array)

      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, banners)
    end
  end
end
