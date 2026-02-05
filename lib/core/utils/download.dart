import 'download_stub.dart' if (dart.library.html) 'download_web.dart' as impl;

class DownloadUtils {
  static Future<bool> file(
    String url, {
    String? fileName,
  }) {
    return impl.downloadFile(url, fileName: fileName);
  }
}

