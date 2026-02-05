// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

Future<bool> downloadFile(
  String url, {
  String? fileName,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;

  final href = _resolveHref(trimmed);
  final name = fileName ?? _inferFileName(trimmed);

  final anchor = html.AnchorElement(href: href)
    ..download = name
    ..target = '_blank'
    ..rel = 'noopener';

  html.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return true;
}

String _resolveHref(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;
  if (uri.hasScheme) return url;
  if (url.startsWith('assets/')) return 'assets/$url';
  return url;
}

String _inferFileName(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.pathSegments.isEmpty) return 'download';
  final last = uri.pathSegments.last;
  return last.isEmpty ? 'download' : last;
}
