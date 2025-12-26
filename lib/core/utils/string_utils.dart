String safeString(dynamic v, [String fallback = '-']) {
  if (v == null) return fallback;
  if (v is! String) return v.toString();
  return v.isNotEmpty ? v : fallback;
}
