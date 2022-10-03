import { ajax } from "discourse/lib/ajax";
import { inject as service } from "@ember/service";

export default Ember.Controller.extend({
  dialog: service(),

  init: async function() {
    this._super();

    const threadBannerData = await ajax("/thread-banner/config.json", {type: 'get'});
    this.set('bannerItems', threadBannerData || []);
  },

  actions: {
    removeBannerItem: function(item) {
      if (this.get('isSaving')) {
        return;
      }

      const items = this.get('bannerItems');
      this.set('bannerItems', item.filter(it => it !== item));
    },
    addNewBannerItem: function() {
      if (this.get('isSaving')) {
        return;
      }

      const items = this.get('bannerItems');
      this.set('bannerItems', [
        ...items,
        {
          bannerTitle: "",
          categoryName: "",
          bannerAdvert: "",
          bannerImage: "",
          bannerCtaText: "",
          bannerCta: ""
        }
      ]);
    },
    saveChanges: async function() {
      this.set('isSaving', true);


      for (const banner of this.get('bannerItems')) {
        if (!(banner.bannerImage instanceof File)) {
          continue;
        }

        const formData = new FormData();
        formData.append("type","card_background")
        formData.append("synchronous","true")
        formData.append("file", banner.bannerImage)
        const uploadResult = await ajax("/uploads.json", {
          type: "POST",
          data: formData,
          cache: false,
          contentType: false,
          processData: false,
        });

        uploadResult.name = banner.bannerImage.name;
        banner.bannerImage = uploadResult;
      }

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
