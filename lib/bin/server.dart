import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

String? latestLabel; // ✅ Simpan label terakhir

void main() async {
  final router = Router();

  // GET /task?label=...
  router.get('/task', (Request request) {
    final label = request.requestedUri.queryParameters['label'];
    final poll = request.requestedUri.queryParameters['poll'];

    if (poll == 'true') {
      if (latestLabel != null) {
        final labelToSend = latestLabel!;
        latestLabel = null; // hanya kirim sekali
        return Response.ok(jsonEncode({'message': labelToSend}));
      } else {
        return Response.ok(jsonEncode({'message': ''})); // kosong = tidak ada
      }
    }

    if (label == null || label.isEmpty) {
      return Response(400, body: jsonEncode({'error': 'Label is missing'}));
    }

    latestLabel = label; // ✅ Simpan label yang dikirim Python
    print('✅ Label diterima: $label');
    return Response.ok(
      jsonEncode({'status': 'OK', 'message': 'Label "$label" received'}),
    );
  });

  // Serve UI statis dari folder /web
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