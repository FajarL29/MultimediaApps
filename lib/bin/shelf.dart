import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 5000);
  print(
      '✅ Server listening on http://${server.address.address}:${server.port}');
}

Response _router(Request request) {
  final path = request.url.path;
  final method = request.method;

  print('📥 Path: $path | Method: $method');

  if (path == 'play-sound' && method == 'GET') {
    final params = request.url.queryParameters;
    final language = params['language'];
    final label = params['label'];

    if (language == null || label == null) {
      return Response.badRequest(
        body: jsonEncodePretty({
          "status": "error",
          "message": "Parameter 'language' dan 'label' wajib ada"
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    print('🎧 == REQUEST DITERIMA ==');
    print('🌐 Language: $language');
    print('💡 Label   : $label');

    final response = {
      "status": "success",
      "message": "Data berhasil diterima",
      "data_diterima": {
        "language": language,
        "label": label,
      }
    };

    return Response.ok(
      jsonEncodePretty(response),
      headers: {'Content-Type': 'application/json'},
    );
  }

  return Response.notFound(
    jsonEncodePretty(
        {"status": "error", "message": "Endpoint tidak ditemukan"}),
    headers: {'Content-Type': 'application/json'},
  );
}

String jsonEncodePretty(Object data) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(data);
}
