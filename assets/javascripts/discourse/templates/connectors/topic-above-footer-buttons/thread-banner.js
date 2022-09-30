import { withPluginApi } from "discourse/lib/plugin-api";
import { renderThreadBanner } from "discourse/plugins/thread-banner/lib/render-thread-banner";

export default {
  setupComponent(args, component) {
    withPluginApi("*", async (api) => {
      if (api.getCurrentUser()) {

        await renderThreadBanner(this, args.model);
      }
    });
  },
};
