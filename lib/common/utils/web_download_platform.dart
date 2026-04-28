// A single import point that conditionally selects the right implementation.
//
// - Web(JS interop available): uses `dart:js_interop` to call JS download func.
// - Others(VM tests/mobile/desktop): throws UnsupportedError.

export 'web_download_stub.dart'
    if (dart.library.js_interop) 'web_download_web.dart';

