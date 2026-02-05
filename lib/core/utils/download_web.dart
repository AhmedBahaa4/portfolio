// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

Future<bool> downloadFile(
  String url, {
  String? fileName,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;

  final href = await _resolveDownloadHref(trimmed);
  if (href == null) return false;
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

Future<String?> _resolveDownloadHref(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return Uri.base.resolve(url).toString();
  if (uri.hasScheme) return uri.toString();

  final candidates = _candidateRelativeUrls(url)
      .map((value) => Uri.base.resolve(value).toString())
      .toList(growable: false);

  for (final candidate in candidates) {
    if (await _exists(candidate)) return candidate;
  }

  return null;
}

List<String> _candidateRelativeUrls(String url) {
  if (url.startsWith('assets/assets/')) {
    return [
      url,
      url.replaceFirst('assets/assets/', 'assets/'),
    ];
  }

  if (url.startsWith('assets/')) {
    return [
      'assets/$url',
      url,
    ];
  }

  return [url];
}

Future<bool> _exists(String href) async {
  try {
    final response = await html.HttpRequest.request(href, method: 'HEAD');
    final status = response.status ?? 0;
    if (status >= 200 && status < 400) return true;
  } catch (_) {
  }

  try {
    final response = await html.HttpRequest.request(
      href,
      method: 'GET',
      responseType: 'arraybuffer',
      requestHeaders: const {'Range': 'bytes=0-0'},
    );
    final status = response.status ?? 0;
    return status >= 200 && status < 400;
  } catch (_) {
    return false;
  }
}

String _inferFileName(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null || uri.pathSegments.isEmpty) return 'download';
  final last = uri.pathSegments.last;
  return last.isEmpty ? 'download' : last;
}
