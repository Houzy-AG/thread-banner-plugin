// Normalizes GET /thread-banner/config.json responses across plugin versions.
// - Current API: a plain banner array
// - Legacy API / store: { config: [...] }
// - Legacy admin save: JSON string of an array (parsed by ajax)
export default function parseBannerConfig(data) {
  if (Array.isArray(data)) {
    return data;
  }

  if (data && typeof data === "object") {
    const wrapped = data.config ?? data.banners;
    if (Array.isArray(wrapped)) {
      return wrapped;
    }
  }

  return [];
}
