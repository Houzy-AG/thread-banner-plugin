export default {
  resource: "admin.adminPlugins.show",

  path: "/plugins",

  map() {
    this.route("thread-banner-banners", { path: "banners" });
  },
};
