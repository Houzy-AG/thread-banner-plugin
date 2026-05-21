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
      return data if data.is_a?(Array)

      if data.is_a?(String)
        parsed = JSON.parse(data)
        return parsed if parsed.is_a?(Array)
      end

      []
    rescue JSON::ParserError
      []
    end

    def persist_parsed_config(raw, banners)
      return unless raw.is_a?(String) && banners.is_a?(Array)

      PluginStore.set(STORE_NAMESPACE, CONFIG_KEY, banners)
    end
  end
end
