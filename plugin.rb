# frozen_string_literal: true

# name: thread-banner
# about: Adds category-targeted promotional banners to topic pages, managed from a plugin admin page.
# version: 0.2.0
# authors: Houzy
# url: https://github.com/Houzy-AG/thread-banner-plugin
# required_version: 2026.1.0

enabled_site_setting :thread_banner_enabled

register_asset "stylesheets/thread-banner.scss"
register_asset "stylesheets/thread-banner-admin.scss"

module ::ThreadBanner
  PLUGIN_NAME = "thread-banner"
  STORE_NAMESPACE = "thread_banner"
end

require_relative "lib/thread_banner/engine"
require_relative "lib/thread_banner/config_store"
require_relative "lib/thread_banner/migrations"

after_initialize do
  ::ThreadBanner::Migrations.run!
  add_admin_route("thread_banner.title", "thread-banner", { use_new_show_route: true })
end
