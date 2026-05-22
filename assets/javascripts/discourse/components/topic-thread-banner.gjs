import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import findThreadBanner from "../lib/find-thread-banner";
import parseBannerConfig from "../lib/parse-banner-config";
import ThreadBanner from "./thread-banner";

export default class TopicThreadBanner extends Component {
  @tracked banner = null;

  constructor() {
    super(...arguments);
    this.loadBanner();
  }

  async loadBanner() {
    try {
      const data = await ajax("/thread-banner/config.json");
      const banners = parseBannerConfig(data);
      this.banner = findThreadBanner(banners, this.args.topic?.category?.name);
    } catch {
      this.banner = null;
    }
  }

  <template>
    {{#if this.banner}}
      <ThreadBanner @banner={{this.banner}} @position={{@position}} />
    {{/if}}
  </template>
}
