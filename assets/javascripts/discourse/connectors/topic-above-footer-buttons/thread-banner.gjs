import Component from "@glimmer/component";
import { service } from "@ember/service";
import TopicThreadBanner from "../../components/topic-thread-banner";

export default class ThreadBannerAboveFooterButtons extends Component {
  @service currentUser;

  <template>
    {{#if this.currentUser}}
      <TopicThreadBanner
        @topic={{@outletArgs.model}}
        @position="hzy-thread-banner-above-footer-buttons"
      />
    {{/if}}
  </template>
}
