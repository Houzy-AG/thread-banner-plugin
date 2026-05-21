import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { ajax } from "discourse/lib/ajax";
import findThreadBanner from "../lib/find-thread-banner";
import ThreadBanner from "./thread-banner";

export default class TopicThreadBanner extends Component {
  @tracked banner = null;

  constructor() {
    super(...arguments);
    this.loadBanner();
  }

  async loadBanner() {
    try {
      const banners = await ajax("/thread-banner/config.json");
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
