import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MediaKitStreamingPage extends StatefulWidget {
  @override
  State<MediaKitStreamingPage> createState() => _MediaKitStreamingPageState();
}

class _MediaKitStreamingPageState extends State<MediaKitStreamingPage> {
  Player? player;
  VideoController? controller;
  IO.Socket? socket;
  File? extractedPcm;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setup();
  }

  Future<void> setup() async {
    await initMediaKit();
    connectToServer();
    setState(() => isReady = true);
  }

  Future<void> initMediaKit() async {
    final tempDir = await getTemporaryDirectory();
    final videoBytes = await rootBundle.load("assets/video/teaser.mp4");
    final videoPath = '${tempDir.path}/video.mp4';
    final videoFile = File(videoPath);
    await videoFile.writeAsBytes(videoBytes.buffer.asUint8List());

    player = Player(configuration: PlayerConfiguration());
    controller = VideoController(player!);

    await player!.open(Media(videoFile.path));
    await extractPcmFromVideo(videoFile.path);
  }

  Future<void> extractPcmFromVideo(String videoPath) async {
    final tempDir = await getTemporaryDirectory();
    final pcmPath = "${tempDir.path}/audio.pcm";

    final command =
        "-i $videoPath -f s16le -acodec pcm_s16le -ac 1 -ar 44100 $pcmPath";

    print("Running FFmpeg...");
    await FFmpegKit.execute(command);

    extractedPcm = File(pcmPath);
    print("PCM saved at: $pcmPath");
  }

  void connectToServer() {
    socket = IO.io(
      'http://10.0.0.75:5000', // GANTI DENGAN IP SERVER
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) => print("Connected to server"));
    socket!.onDisconnect((_) => print("Disconnected from server"));
    socket!.connect();
  }

  Future<void> streamPcm() async {
    if (extractedPcm == null || socket == null || !socket!.connected) return;

    final stream = extractedPcm!.openRead();
    const chunkSize = 1024;

    await for (final chunk in stream) {
      socket!.emit('audio_chunk', chunk);
      await Future.delayed(Duration(milliseconds: 23)); // real-time pace
    }

    print("Streaming done.");
  }

  void playAndStream() {
    if (player != null) {
      player!.setVolume(0);
      player!.play();
      streamPcm();
    }
  }

  @override
  void dispose() {
    player?.dispose();
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('media_kit Video + Audio Stream')),
      body: isReady && controller != null
          ? Column(
              children: [
                Expanded(child: Video(controller: controller!)),
                ElevatedButton(
                  onPressed: playAndStream,
                  child: Text('Play Video & Stream Audio'),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
