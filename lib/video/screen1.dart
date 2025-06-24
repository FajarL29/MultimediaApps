import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class MyScreen1 extends StatefulWidget {
  const MyScreen1({Key? key}) : super(key: key);
  @override
  State<MyScreen1> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen1> {
  late final player = Player();
  late final controller = VideoController(player);

  @override
  void initState() {
    super.initState();
    player.open(Media('asset:///assets/video/BukaTutup_KapMobil.mp4'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 9.0 / 16.0,
              child: Video(controller: controller),
            ),
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            child: IconButton(
              icon: Icon(Icons.close_fullscreen_rounded, color: Colors.red),
              onPressed: () => Navigator.pop(context),
              tooltip: 'Close',
            ),
          ),
        ],
      ),
    );
  }
}
