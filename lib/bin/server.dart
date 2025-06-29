import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

String? latestLabel;
String? latestLanguage;

void main() async {
  final router = Router();

  // == Unified GET /task ==
  router.get('/task', (Request request) {
    final label = request.requestedUri.queryParameters['label'];
    final language = request.requestedUri.queryParameters['language'];
    final poll = request.requestedUri.queryParameters['poll'];

    if (poll == 'true') {
      if (latestLabel != null && latestLanguage != null) {
        final result = {
          'label': latestLabel!,
          'language': latestLanguage!,
        };
        latestLabel = null;
        latestLanguage = null;
        return Response.ok(jsonEncode(result),
            headers: {'Content-Type': 'application/json'});
      } else {
        return Response.ok(jsonEncode({'label': '', 'language': ''}),
            headers: {'Content-Type': 'application/json'});
      }
    }

    // Validasi parameter wajib
    if (label == null ||
        language == null ||
        label.isEmpty ||
        language.isEmpty) {
      return Response.badRequest(
        body: jsonEncodePretty({
          "status": "error",
          "message": "Parameter 'label' dan 'language' wajib ada"
        }),
        headers: {'Content-Type': 'application/json'},
      );
    }

    latestLabel = label;
    latestLanguage = language;

    print('🎧 == DATA DITERIMA ==');
    print('🌐 Language: $language');
    print('💡 Label   : $label');

    return Response.ok(
      jsonEncode({
        "status": "success",
        "message": "Label dan bahasa diterima",
        "data": {
          "label": label,
          "language": language,
        }
      }),
      headers: {'Content-Type': 'application/json'},
    );
  });

  // == Static Web Folder ==
  final staticHandler = createStaticHandler(
    'web',
    defaultDocument: 'index.html',
  );

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(Cascade().add(router).add(staticHandler).handler);

  final server = await serve(handler, InternetAddress.anyIPv4, 5000);
  print('✅ Server listening on http://${server.address.host}:${server.port}');
}

String jsonEncodePretty(Object data) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(data);
}
