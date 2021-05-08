import 'dart:io';

import 'package:apna_classroom_app/analytics/analytics_constants.dart';
import 'package:apna_classroom_app/analytics/analytics_manager.dart';
import 'package:apna_classroom_app/api/storage/storage_api_constants.dart';
import 'package:apna_classroom_app/components/skeletons/details_skeleton.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/widgets/video_player_overlay.dart';
import 'package:apna_classroom_app/util/file_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ApnaVideoPlayer extends StatefulWidget {
  final String title;
  final File file;
  final String url;

  const ApnaVideoPlayer({Key key, this.title, this.file, this.url})
      : super(key: key);

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
    // Set back to normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _initController();

    super.initState();
  }

  // Init video controller
  _initController() async {
    if (!mounted) return;
    // If video is from file
    if (widget.file != null) {
      _controller = VideoPlayerController.file(widget.file)..setLooping(true);
    }

    // If video is from url
    else if (widget.url != null) {
      File file = await getFile(
        widget.url,
        name: FileName.MAIN,
        onLoadFinish: _initController,
      );
      if (file == null) {
        return;
      }
      _controller = VideoPlayerController.file(file)..setLooping(true);
    }

    _initializeVideoPlayerFuture = _controller.initialize().then(
          (value) => _controller.play(),
        );

    _initializeVideoPlayerFuture
        .onError((error, stackTrace) => _initController());

    // To load screen
    setState(() {});

    // Track event
    track(EventName.VIDEO_PLAYER, {});
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    if (_controller != null) _controller.dispose();

    // Set back to normal
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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

  // set quality
  // _setQuality(String quality) {
  //   _controller.pause();
  //   _initController(quality: quality);
  //   setState(() {
  //     overlayActive = false;
  //   });
  //   setLastUsedVideoQuality(quality);
  // }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? S.VIDEO.tr),
        ),
        body: Column(
          children: [
            SizedBox(height: 64),
            Text(
              S.PROCESSING.tr,
              style: Theme.of(context).textTheme.headline6,
            ),
            DetailsSkeleton(type: DetailsType.Image),
          ],
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black87,
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
              title: widget.title,
              // qualities: widget.qualities,
              // setQuality: _setQuality,
              // overlaySwitch: _overlaySwitch,
            )
        ],
      ),
    );
  }
}
