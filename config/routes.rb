# frozen_string_literal: true

ThreadBanner::Engine.routes.draw do
  get "/config" => "config#index"
  put "/config" => "config_admin#update"
end

Discourse::Application.routes.draw { mount ::ThreadBanner::Engine, at: "thread-banner" }
