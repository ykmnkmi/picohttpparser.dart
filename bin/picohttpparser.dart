// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:picohttpparser/picohttpparser.dart';

// Example request from Firefox browser
// to https://developer.mozilla.org/docs/Web/HTTP/Messages
const request = '''
GET /en-US/docs/Web/HTTP/Messages HTTP/1.1\r
Host: developer.mozilla.org\r
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r
Accept-Language: en-US,en;q=0.5\r
Accept-Encoding: gzip, deflate, br, zstd\r
Connection: keep-alive\r
Referer: https://developer.mozilla.org/en-US/docs/Web/HTTP/Messages\r
Upgrade-Insecure-Requests: 1\r
Sec-Fetch-Dest: document\r
Sec-Fetch-Mode: navigate\r
Sec-Fetch-Site: same-origin\r
Sec-Fetch-User: ?1\r
\r
''';

void main() {
  var arena = Arena();

  try {
    var buf = request.toNativeUtf8(allocator: arena);
    var method = arena<Pointer<Uint8>>();
    var method_len = arena<Size>();
    var path = calloc<Pointer<Uint8>>();
    var path_len = calloc<Size>();
    var minor_version = calloc<Int>();
    var headers = calloc<phr_header>();
    var num_headers = calloc<Size>();

    var len = buf.length;
    var last_len = 0;

    var result = phrParseRequest(
      buf.cast<Uint8>(),
      len,
      method,
      method_len,
      path,
      path_len,
      minor_version,
      headers,
      num_headers,
      last_len,
    );

    if (result == -1) {
      print('Failed to parse request');
    } else if (result == -2) {
      print('Request is partial');
    } else {
      print('Method: $method');
      print('Method length: $method_len');
      print('Path: $path');
      print('Path length: $path_len');
      print('Minor version: $minor_version');
      print('Headers: $headers');
      print('Number of headers: $num_headers');
    }
  } finally {
    arena.releaseAll();
  }
}
