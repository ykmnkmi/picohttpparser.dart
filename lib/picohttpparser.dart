// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:ffi';

// contains name and value of a header (name == NULL if is a continuing line
// of a multiline header
final class phr_header extends Struct {
  external Pointer<Uint8> name;

  @Size()
  external int name_len;

  external Pointer<Uint8> value;

  @Size()
  external int value_len;
}

typedef phr_parse_request = Int Function(
  Pointer<Uint8> buf,
  IntPtr len,
  Pointer<Pointer<Uint8>> method,
  Pointer<Size> method_len,
  Pointer<Pointer<Uint8>> path,
  Pointer<Size> path_len,
  Pointer<Int> minor_version,
  Pointer<phr_header> headers,
  Pointer<Size> num_headers,
  Size last_len,
);

// returns number of bytes consumed if successful, -2 if request is partial,
// -1 if failed
@Native<phr_parse_request>(symbol: 'phr_parse_request')
external int phrParseRequest(
  Pointer<Uint8> buf,
  int len,
  Pointer<Pointer<Uint8>> method,
  Pointer<Size> method_len,
  Pointer<Pointer<Uint8>> path,
  Pointer<Size> path_len,
  Pointer<Int> minor_version,
  Pointer<phr_header> headers,
  Pointer<Size> num_headers,
  int last_len,
);
