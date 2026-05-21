# frozen_string_literal: true

module ::ThreadBanner
  module Migrations
    LEGACY_SITE_SETTING = "plugin_name_enabled"
    SITE_SETTING_MIGRATION_KEY = "migrated_plugin_name_enabled"

    module_function

    def run!
      migrate_legacy_site_setting!
    end

    def migrate_legacy_site_setting!
      return if PluginStore.get(STORE_NAMESPACE, SITE_SETTING_MIGRATION_KEY)

      legacy = SiteSetting.find_by(name: LEGACY_SITE_SETTING)
      if legacy
        SiteSetting.thread_banner_enabled =
          ActiveModel::Type::Boolean.new.cast(legacy.value)
        legacy.destroy
      end

      PluginStore.set(STORE_NAMESPACE, SITE_SETTING_MIGRATION_KEY, true)
    end
  end
end
