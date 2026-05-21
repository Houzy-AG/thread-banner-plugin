import { withPluginApi } from "discourse/lib/plugin-api";

// Registers the "Banners" tab on the plugin's admin show page. The route-map
// defines the route; this initializer makes the nav tab appear.
export default {
  name: "thread-banner-admin-plugin-configuration-nav",

  initialize(container) {
    const currentUser = container.lookup("service:current-user");
    if (!currentUser?.admin) {
      return;
    }

    withPluginApi((api) => {
      api.addAdminPluginConfigurationNav("thread-banner", [
        {
          label: "thread_banner.banners",
          route: "adminPlugins.show.thread-banner-banners",
        },
      ]);
    });
  },
};
