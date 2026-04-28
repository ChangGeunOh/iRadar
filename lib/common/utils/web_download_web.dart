import 'dart:typed_data';
import 'dart:js_interop';

// NOTE: The `@JS` annotation is provided by `dart:js_interop` in recent SDKs.
// This avoids `package:js` (not WASM compatible) while still enabling static
// JS interop.

@JS('iRadarDownload.downloadBytes')
external void _downloadBytesJs(
  JSUint8Array bytes,
  String fileName,
  String? mimeType,
);

abstract final class WebDownloadPlatform {
  static void saveBytes(
    Uint8List bytes, {
    required String fileName,
    required String mimeType,
  }) {
    // Uint8List -> JS Uint8Array
    final jsBytes = bytes.toJS;
    _downloadBytesJs(jsBytes, fileName, mimeType);
  }
}

