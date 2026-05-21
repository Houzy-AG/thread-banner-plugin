# Thread Banner

A Discourse plugin that displays category-targeted promotional banners on topic pages.

Staff manage a list of banners (title, category, image, advert text, call-to-action) from an
admin page at **Admin → Plugins → Thread Banner**. On each topic, the banner whose category
list matches the topic's category is shown — above the footer buttons for signed-in users, and
above the suggested topics for anonymous visitors.

## Requirements

Discourse **2026.1.0** or newer (calendar versioning). Houzy runs **v2026.1.4**. Older cores
are pinned to the pre-rewrite plugin commit via `.discourse-compatibility`.

## Installation

Follow the standard [Install Plugins guide](https://meta.discourse.org/t/install-plugins-in-discourse/19157):
add the repo to the `hooks` section of your `app.yml`, then `./launcher rebuild app`.

## Configuration

Enable via the `thread_banner_enabled` site setting (on by default), then add banners at
`/admin/plugins/thread-banner/banners`. The `categories` field is a comma-separated list of
category names a banner should appear on.

## Upgrading from v0.0.x

On first boot after upgrading to v0.2.0, the plugin:

- Copies `plugin_name_enabled` → `thread_banner_enabled` (then removes the old setting).
- Parses legacy PluginStore config if it was saved as a JSON string and re-saves it as an array.

No manual steps are required unless you disabled the plugin under the old setting name and
want to confirm the new `thread_banner_enabled` value in **Admin → Settings → Plugins**.
