import Component from "@glimmer/component";

export default class ThreadBanner extends Component {
  get linkTarget() {
    return this.args.banner.openLinkInNewTab ? "_blank" : "_self";
  }

  <template>
    <div class="hzy-thread-banner {{@position}}">
      <div class="hzy-thread-banner__left">
        {{#if @banner.bannerImage}}
          <div class="hzy-thread-banner__img">
            <img src={{@banner.bannerImage}} alt={{@banner.bannerTitle}} />
          </div>
        {{/if}}
      </div>
      <div class="hzy-thread-banner__right">
        {{#if @banner.bannerTitle}}
          <div class="hzy-thread-banner__title">{{@banner.bannerTitle}}</div>
        {{/if}}
        {{#if @banner.bannerAdvert}}
          <div class="hzy-thread-banner__advert">{{@banner.bannerAdvert}}</div>
        {{/if}}
        <div class="hzy-thread-banner__cta__spacer"></div>
        {{#if @banner.bannerCta}}
          {{#if @banner.bannerCtaText}}
            <a
              href={{@banner.bannerCta}}
              class="btn btn-default hzy-thread-banner__cta"
              target={{this.linkTarget}}
              rel="noopener"
            >
              {{@banner.bannerCtaText}}
            </a>
          {{/if}}
        {{/if}}
      </div>
    </div>
  </template>
}
