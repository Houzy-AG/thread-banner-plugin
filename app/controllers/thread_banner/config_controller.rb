# frozen_string_literal: true

module ::ThreadBanner
  class ConfigController < ::ApplicationController
    requires_plugin PLUGIN_NAME

    def index
      render json: ConfigStore.read
    end
  end
end
