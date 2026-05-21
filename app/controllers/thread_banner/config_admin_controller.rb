# frozen_string_literal: true

module ::ThreadBanner
  class ConfigAdminController < ::Admin::AdminController
    requires_plugin PLUGIN_NAME

    BANNER_ATTRIBUTES = %w[
      bannerTitle
      categories
      bannerAdvert
      bannerImage
      bannerCtaText
      bannerCta
      openLinkInNewTab
    ].freeze

    def update
      ConfigStore.write(submitted_banners)
      render json: success_json
    end

    private

    # Reads the banner list straight from the JSON request body. We avoid
    # params.permit here: the banners arrive as a JSON array, and permit's
    # array-of-hashes handling raises when the payload shape is unexpected.
    def submitted_banners
      payload = JSON.parse(request.raw_post)
      list = payload.is_a?(Hash) ? payload["banners"] : payload
      return [] unless list.is_a?(Array)

      list.filter_map { |banner| banner.slice(*BANNER_ATTRIBUTES) if banner.is_a?(Hash) }
    rescue JSON::ParserError
      []
    end
  end
end
