import 'package:flutter/foundation.dart';

import 'web_download_platform.dart';

/// Web-only download utility.
///
/// - Web/JS interop 환경에서는 실제 JS 다운로드 함수를 호출합니다.
/// - 그 외(VM 테스트/모바일/데스크톱 등)에서는 UnsupportedError를 던집니다.
///
/// 이렇게 분리하면 `flutter test`(VM)에서 `dart:js_interop` import로 인한
/// 컴파일 실패를 피하면서, Web/WASM 빌드는 계속 지원할 수 있습니다.
class WebDownload {
  static void saveBytes(
    Uint8List bytes, {
    required String fileName,
    String mimeType = 'application/octet-stream',
  }) {
    if (!kIsWeb) {
      throw UnsupportedError('WebDownload is only supported on web');
    }

    WebDownloadPlatform.saveBytes(
      bytes,
      fileName: fileName,
      mimeType: mimeType,
    );
  }
}

