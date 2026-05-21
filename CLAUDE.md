# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

A Discourse plugin ("thread-banner") that lets staff define category-targeted promotional
banners and renders them on topic pages. Banners are configured in an admin page and stored
as a JSON array in `PluginStore`; on each topic the frontend picks the banner whose category
list matches the topic's category.

This plugin was modernized (v0.2.0) from pre-2022 Discourse conventions to the current
`.gjs` / Glimmer / Rails-7 plugin layout. Targets Discourse **2026.1+** (Houzy: **v2026.1.4**);
older cores use the pinned commit in `.discourse-compatibility`.

## Commands

No standalone build — the plugin runs inside a Discourse install. Tooling is pnpm-based
(Node ≥ 22). From the repo root:

```
pnpm install
pnpm lint              # runs lint:js, lint:css, lint:prettier together
pnpm lint:fix          # autofix
bundle install && bundle exec rubocop .
```

Tests: none yet (`spec/` and `test/javascripts/` hold only `.gitkeep`). The plugin cannot be
tested in isolation — it must be checked out into a Discourse install under `plugins/`. CI is
the reusable `discourse/.github` workflow (`.github/workflows/discourse-plugin.yml`). To run a
single test from a Discourse checkout root once tests exist:

- Backend: `bin/rake plugin:spec[thread-banner]`
- Frontend: `bin/ember-cli --test-page "tests/index.html?filter=thread+banner"`

## Architecture

### Backend (Rails)

- `plugin.rb` — metadata, `enabled_site_setting :thread_banner_enabled`, registers the SCSS
  assets, defines the `::ThreadBanner` module (with `PLUGIN_NAME` and `STORE_NAMESPACE`),
  requires the engine, and registers the admin route via
  `add_admin_route(..., use_new_show_route: true)`.
- `lib/thread_banner/engine.rb` — the isolated Rails engine.
- `config/routes.rb` — mounts the engine at `/thread-banner` with `GET /config` (public read)
  and `PUT /config` (staff write).
- `app/controllers/thread_banner/config_controller.rb` — public read; returns the stored
  banner array. Reachable anonymously because the topic banner renders for logged-out users.
- `app/controllers/thread_banner/config_admin_controller.rb` — `< Admin::AdminController`
  (staff only); replaces the whole list, filtering params to `BANNER_ATTRIBUTES`.
- `lib/thread_banner/config_store.rb` — read/write PluginStore config; parses legacy JSON strings.
- `lib/thread_banner/migrations.rb` — one-time `plugin_name_enabled` → `thread_banner_enabled`.

Storage is a single `PluginStore` entry: key `"config"` under namespace **`thread_banner`**
(underscore). Preserved from the pre-rewrite version for data continuity.

### Frontend (Glimmer / `.gjs`)

Topic display (`assets/javascripts/discourse/`):
- `connectors/topic-above-footer-buttons/thread-banner.gjs` — renders for **signed-in** users.
- `connectors/topic-above-suggested/thread-banner.gjs` — renders for **anonymous** users.
  (This signed-in/anonymous split is inherited behavior; both connectors share one component.)
- `components/topic-thread-banner.gjs` — fetches the config and selects the matching banner.
- `components/thread-banner.gjs` — presentational banner (image, title, advert, CTA).
- `lib/find-thread-banner.js` — category-match helper.

Admin (`admin/assets/javascripts/`):
- `assets/javascripts/discourse/admin-thread-banner-plugin-route-map.js` — registers the
  `adminPlugins.show.thread-banner-banners` route at `/admin/plugins/thread-banner/banners`.
- `admin/.../templates/admin-plugins/show/thread-banner-banners.gjs` — `RouteTemplate` that
  renders the admin component.
- `admin/assets/javascripts/admin/components/thread-banner-admin.gjs` — the editor: loads the
  list, edits in memory with `@tracked`, saves via `PUT /thread-banner/config`.

### Data flow

Admin edits → `PUT /thread-banner/config` `{ banners: [...] }` → `PluginStore`. Topic page →
`GET /thread-banner/config.json` → `findThreadBanner` matches the topic's category name → render.
A banner item: `bannerTitle`, `categories` (comma-separated), `bannerAdvert`, `bannerImage`,
`bannerCtaText`, `bannerCta`, `openLinkInNewTab`.

## Conventions & gotchas

- i18n: admin-bundle code (everything under `admin/assets/` and the admin route label) resolves
  keys under `admin_js:` in `config/locales/client.en.yml`. The topic-display side uses no i18n.
- CSS class names (`hzy-thread-banner*`) are load-bearing for the two SCSS files in
  `assets/stylesheets/` — keep them in sync if you rename anything.
- Version-sensitive surfaces to verify after a Discourse upgrade: the plugin-outlet names
  `topic-above-footer-buttons` / `topic-above-suggested` still existing and passing the topic
  as `@outletArgs.model`, and the admin nav-tab label/route under the new plugin show route.
- The plugin's name is `thread-banner` (drives the `discourse/plugins/thread-banner/...` import
  namespace); the repository is `thread-banner-plugin`.
