import Component from "@glimmer/component";
import { service } from "@ember/service";
import TopicThreadBanner from "../../components/topic-thread-banner";

export default class ThreadBannerAboveSuggested extends Component {
  @service currentUser;

  <template>
    {{#unless this.currentUser}}
      <TopicThreadBanner
        @topic={{@outletArgs.model}}
        @position="hzy-thread-banner-above-suggested"
      />
    {{/unless}}
  </template>
}
