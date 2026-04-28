import 'dart:typed_data';

/// Non-web / non-js_interop implementation.
///
/// This file is selected by conditional import/export when `dart.library.js_interop`
/// is unavailable (e.g. VM tests, mobile, desktop).
abstract final class WebDownloadPlatform {
  static void saveBytes(
	Uint8List bytes, {
	required String fileName,
	required String mimeType,
  }) {
	throw UnsupportedError('WebDownload is only supported on web');
  }
}

