# frozen_string_literal: true

module ::ThreadBanner
  class ConfigAdminController < ::Admin::AdminController
    requires_plugin PLUGIN_NAME

    BANNER_ATTRIBUTES = %i[
      bannerTitle
      categories
      bannerAdvert
      bannerImage
      bannerCtaText
      bannerCta
      openLinkInNewTab
    ].freeze

    def update
      banners = params.permit(banners: BANNER_ATTRIBUTES)[:banners] || []
      ConfigStore.write(banners.map(&:to_h))
      render json: success_json
    end
  end
end
