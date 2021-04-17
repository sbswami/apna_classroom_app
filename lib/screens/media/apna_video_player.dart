import 'package:apna_classroom_app/screens/media/widgets/video_player_overlay.dart';
import 'package:apna_classroom_app/util/c.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class ApnaVideoPlayer extends StatefulWidget {
  final media;

  const ApnaVideoPlayer({Key key, this.media}) : super(key: key);
  @override
  _ApnaVideoPlayerState createState() => _ApnaVideoPlayerState();
}

class _ApnaVideoPlayerState extends State<ApnaVideoPlayer> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  // Var
  bool overlayActive = false;

  @override
  void initState() {
    // Only Horizontal via
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide status bar
    SystemChrome.setEnabledSystemUIOverlays([]);

    _controller = VideoPlayerController.network(
      'http://192.168.108.180:4000/file/stream?path=this_is_uid_12345/videos/movie.mkv',
    )..setLooping(true);
    // ..initialize().then((value) => _controller.play);

    _initializeVideoPlayerFuture = _controller.initialize();

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    // Set back to normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  // Play + Pause
  _playPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // If the video is paused, play it.
        _controller.play();
      }
    });
  }

  // Overlay switch
  _overlaySwitch() {
    setState(() {
      overlayActive = !overlayActive;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
              }
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    // Use the VideoPlayer widget to display the video.
                    child: VideoPlayer(_controller),
                  ),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          if (overlayActive)
            Container(
              color: Colors.black45,
            ),
          GestureDetector(
            onTap: _overlaySwitch,
            behavior: HitTestBehavior.opaque,
          ),
          if (overlayActive)
            VideoPlayerOverlay(
              controller: _controller,
              playPause: _playPause,
              title: (widget.media ?? {})[C.TITLE],
              // overlaySwitch: _overlaySwitch,
            )
        ],
      ),
    );
  }
}
