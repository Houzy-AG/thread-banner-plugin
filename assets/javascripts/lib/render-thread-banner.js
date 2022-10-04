import { ajax } from "discourse/lib/ajax";

export const renderThreadBanner = async (component,
                                         model) => {
  component.set('showBanner', false);
  const category = model.get('category');
  const categoryName = category?.name;

  const bannersListByCategory = await ajax("/thread-banner/config.json", {type: 'get'});
  const bannerData = bannersListByCategory.find(banner => {
    banner.categories = !banner.categories ? "" : banner.categories;
    const categoriesList = banner.categories.split(",")
      .map(item => item.trim());

    return categoriesList.some(category => category === categoryName);
  });
  if (!bannerData) {
    return;
  }
  component.set('bannerImage', bannerData.bannerImage);
  component.set('bannerTitle', bannerData.bannerTitle);
  component.set('bannerAdvert', bannerData.bannerAdvert);
  component.set('bannerCtaText', bannerData.bannerCtaText);
  component.set('bannerCta', bannerData.bannerCta);
  component.set('linkTarget', bannerData.openLinkInNewTab ? '_blank' : '_self');
  component.set('showBanner', true);
}
