import 'package:url_launcher/url_launcher.dart';

class LaunchUtils {
  static Future<bool> url(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    return launchUrl(uri, mode: LaunchMode.platformDefault);
  }

  static Future<bool> email(
    String email, {
    String? subject,
    String? body,
  }) async {
    final query = <String, String>{
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      if (body != null && body.isNotEmpty) 'body': body,
    };

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: query.isEmpty ? null : query,
    );

    return launchUrl(uri, mode: LaunchMode.platformDefault);
  }
}
