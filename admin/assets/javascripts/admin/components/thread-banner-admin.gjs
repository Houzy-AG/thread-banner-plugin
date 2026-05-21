import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Input } from "@ember/component";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";
import { action } from "@ember/object";
import { service } from "@ember/service";
import { ajax } from "discourse/lib/ajax";
import { i18n } from "discourse-i18n";

const BLANK_BANNER = {
  bannerTitle: "",
  categories: "",
  bannerAdvert: "",
  bannerImage: "",
  bannerCtaText: "",
  bannerCta: "",
  openLinkInNewTab: false,
};

// Admin editor for the banner list. Loads the stored config, lets staff
// add/remove/edit banner entries in memory, and saves the whole list back.
//
// Uses plain <button> elements (core `.btn` classes) rather than the DButton
// component on purpose: DButton's import path has moved between Discourse
// versions, and a plain button has no such version coupling.
export default class ThreadBannerAdmin extends Component {
  @service dialog;

  @tracked bannerItems = [];
  @tracked loading = true;
  @tracked saving = false;

  constructor() {
    super(...arguments);
    this.loadBanners();
  }

  async loadBanners() {
    try {
      const data = await ajax("/thread-banner/config.json");
      this.bannerItems = Array.isArray(data) ? data : [];
    } catch {
      this.dialog.alert(i18n("thread_banner.load_data_failed"));
    } finally {
      this.loading = false;
    }
  }

  @action
  addBanner() {
    this.bannerItems = [...this.bannerItems, { ...BLANK_BANNER }];
  }

  @action
  removeBanner(item) {
    this.bannerItems = this.bannerItems.filter((it) => it !== item);
  }

  @action
  async save() {
    this.saving = true;
    try {
      await ajax("/thread-banner/config.json", {
        type: "PUT",
        contentType: "application/json",
        data: JSON.stringify({ banners: this.bannerItems }),
      });
      this.dialog.alert(i18n("thread_banner.save_changes_success"));
    } catch {
      this.dialog.alert(i18n("thread_banner.save_changes_failed"));
    } finally {
      this.saving = false;
    }
  }

  <template>
    <div class="hzy-thread-banner__admin">
      {{#unless this.loading}}
        {{#each this.bannerItems as |item|}}
          <div class="hzy-thread-banner__admin__card">
            <div class="hzy-thread-banner__admin__fields-line">
              <div class="control-group hzy-thread-banner__admin__field">
                <label>{{i18n "thread_banner.add_title"}}</label>
                <Input @value={{item.bannerTitle}} />
              </div>
              <div class="control-group hzy-thread-banner__admin__field">
                <label>{{i18n "thread_banner.category"}}</label>
                <Input @value={{item.categories}} />
              </div>
            </div>

            <div class="control-group hzy-thread-banner__admin__field">
              <label>{{i18n "thread_banner.advert_text"}}</label>
              <Input @value={{item.bannerAdvert}} />
            </div>

            <div class="control-group">
              <label>{{i18n "thread_banner.bannerImage"}}</label>
              <Input @value={{item.bannerImage}} />
            </div>

            <div class="hzy-thread-banner__admin__fields-line">
              <div class="control-group hzy-thread-banner__admin__field">
                <label>{{i18n "thread_banner.cta_link_text"}}</label>
                <Input @value={{item.bannerCtaText}} />
              </div>
              <div class="control-group hzy-thread-banner__admin__field">
                <label>{{i18n "thread_banner.cta_link"}}</label>
                <Input @value={{item.bannerCta}} />
              </div>
            </div>

            <div class="hzy-thread-banner__admin__fields-line">
              <div class="control-group hzy-thread-banner__admin__field">
                <div class="hzy-thread-banner__admin__checkbox-group">
                  <label>{{i18n "thread_banner.open_link_in_new_tab"}}</label>
                  <Input @type="checkbox" @checked={{item.openLinkInNewTab}} />
                </div>
              </div>
            </div>

            <div class="hzy-thread-banner__admin__actions">
              <button
                type="button"
                class="btn btn-danger action-button"
                disabled={{this.saving}}
                {{on "click" (fn this.removeBanner item)}}
              >
                {{i18n "thread_banner.action_remove"}}
              </button>
            </div>
          </div>
        {{/each}}

        <div class="hzy-thread-banner__admin__actions">
          <button
            type="button"
            class="btn btn-primary action-button"
            disabled={{this.saving}}
            {{on "click" this.addBanner}}
          >
            {{i18n "thread_banner.action_add_new"}}
          </button>
          <button
            type="button"
            class="btn btn-primary action-button"
            disabled={{this.saving}}
            {{on "click" this.save}}
          >
            {{i18n "thread_banner.action_save_changes"}}
          </button>
        </div>
      {{/unless}}
    </div>
  </template>
}
