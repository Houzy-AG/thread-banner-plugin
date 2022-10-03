# frozen_string_literal: true

# name: thread-banner
# about: Plugin for customizing threads page with banners.
# version: 0.0.1
# authors: Houzy
# url: TODO
# required_version: 2.7.0
add_admin_route 'thread_banner.title', 'thread-banner'

Discourse::Application.routes.append do
  get '/admin/plugins/thread-banner' => 'admin/plugins#index', constraints: StaffConstraint.new
end

enabled_site_setting :plugin_name_enabled

register_asset 'stylesheets/thread-banner.scss'
register_asset 'stylesheets/thread-banner-admin.scss'

PLUGIN_NAME = "thread_banner".freeze

after_initialize do
    module ::ThreadBanner
        class Engine < ::Rails::Engine
            engine_name PLUGIN_NAME
            isolate_namespace ThreadBanner
        end
    end

    require_dependency "application_controller"
    require_dependency "admin/admin_controller"

    class ThreadBanner::ConfigController < ::ApplicationController
        def index
            render json: PluginStore.get(PLUGIN_NAME, "config")
        end
    end

    class ThreadBanner::ConfigAdminController < ::Admin::AdminController
        def update
            PluginStore.set(PLUGIN_NAME, "config", request.body.read)
        end
    end

    ThreadBanner::Engine.routes.draw do
        get "/config" => "config#index"
        post "/config" => "config_admin#update"
    end

    Discourse::Application.routes.append do
        mount ::ThreadBanner::Engine, at: "thread-banner"
    end
end


