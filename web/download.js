// Minimal download helper for Flutter Web.
//
// This file is called from Dart via JS interop and is intended to avoid
// importing `dart:html` in Dart code (which blocks WASM builds).
//
// NOTE: The Google Maps key is handled separately in env.js.

(function () {
  function bytesToBlob(u8arr, mimeType) {
    // u8arr may be Uint8Array already, or a JS typed array view.
    var bytes = u8arr;
    if (!(bytes instanceof Uint8Array)) {
      bytes = new Uint8Array(bytes);
    }
    return new Blob([bytes], { type: mimeType || 'application/octet-stream' });
  }

  /**
   * Triggers a browser download.
   * @param {Uint8Array} bytes
   * @param {string} fileName
   * @param {string=} mimeType
   */
  function downloadBytes(bytes, fileName, mimeType) {
    if (!bytes) throw new Error('bytes is required');
    if (!fileName) fileName = 'download';

    var blob = bytesToBlob(bytes, mimeType);
    var url = URL.createObjectURL(blob);

    var a = document.createElement('a');
    a.href = url;
    a.download = fileName;
    a.style.display = 'none';
    document.body.appendChild(a);
    a.click();

    setTimeout(function () {
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 0);
  }

  window.iRadarDownload = window.iRadarDownload || {};
  window.iRadarDownload.downloadBytes = downloadBytes;
})();

