import { ajax } from "discourse/lib/ajax";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";

export default Controller.extend({
  dialog: service(),

  init: async function() {
    this._super();

    let threadBannerData = [];
    try {
      threadBannerData =  await ajax("/thread-banner/config.json", {type: 'get'}) || [];
    } catch (e) {
      this.dialog.alert({ message: I18n.t("thread_banner.load_data_failed") });
      console.error(e);
    }
    this.set('bannerItems', threadBannerData || []);
  },

  actions: {
    removeBannerItem: function(item) {
      if (this.get('isSaving')) {
        return;
      }

      const items = this.get('bannerItems') || [];
      this.set('bannerItems', items.filter(it => it !== item));
    },
    addNewBannerItem: function() {
      if (this.get('isSaving')) {
        return;
      }

      const items = this.get('bannerItems') || [];
      this.set('bannerItems', [
        ...items,
        {
          bannerTitle: "",
          categories: "",
          bannerAdvert: "",
          bannerImage: "",
          bannerCtaText: "",
          bannerCta: ""
        }
      ]);
    },
    toggleOpenLinkInNewTab: function(item, eventData) {
      item.openLinkInNewTab = eventData.target.checked;
    },
    saveChanges: async function() {
      this.set('isSaving', true);
      try {
        await ajax("/thread-banner/config.json", {
          type: "POST",
          data: JSON.stringify(this.get('bannerItems')),
          contentType: "application/json; charset=utf-8",
          dataType: "json",
        });
      } catch (e) {
        this.dialog.alert({ message: I18n.t("thread_banner.save_changes_failed") });
        console.error(e);
      } finally {
        this.set('isSaving', false);
      }
    }
  }
});
