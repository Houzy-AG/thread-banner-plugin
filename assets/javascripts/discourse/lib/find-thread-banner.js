export default function findThreadBanner(banners, categoryName) {
  if (!Array.isArray(banners) || !categoryName) {
    return null;
  }

  return (
    banners.find((banner) => {
      const categories = (banner.categories || "")
        .split(",")
        .map((name) => name.trim());
      return categories.includes(categoryName);
    }) || null
  );
}
