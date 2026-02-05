import 'launch.dart';

Future<bool> downloadFile(
  String url, {
  String? fileName,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return false;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return false;

  if (uri.hasScheme) {
    return LaunchUtils.url(trimmed);
  }

  return false;
}

