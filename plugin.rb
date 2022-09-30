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

PLUGIN_NAME = "thread_banner".freeze

after_initialize do
    module ::ThreadBanner
        class Engine < ::Rails::Engine
            engine_name PLUGIN_NAME
            isolate_namespace ThreadBanner
        end
    end

    require_dependency "application_controller"

    class ThreadBanner::ConfigController < ::ApplicationController
        skip_before_action :verify_authenticity_token
        def index
            puts(PluginStore.get(PLUGIN_NAME, "config"))
            render json: PluginStore.get(PLUGIN_NAME, "config")
        end

        def update
            puts(request.body.read)
            PluginStore.set(PLUGIN_NAME, "config", request.body.read)
        end
    end

    ThreadBanner::Engine.routes.draw do
        get "/config" => "config#index"
        post "/config" => "config#update"
    end

    Discourse::Application.routes.append do
        mount ::ThreadBanner::Engine, at: "thread-banner"
    end
end


