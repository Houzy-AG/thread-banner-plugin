import Component from "@ember/component";

export default Component.extend({
  tagName: "div",
  // subclasses need this
  layoutName: "components/thread-banner-ui",
  attributeBindings: [
    "bannerImage",
    "bannerTitle",
    "bannerAdvert",
    "bannerCta",
    "bannerCtaText"
  ],
})
