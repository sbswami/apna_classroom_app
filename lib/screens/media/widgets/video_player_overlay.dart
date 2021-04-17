import 'package:apna_classroom_app/components/menu/apna_menu.dart';
import 'package:apna_classroom_app/components/menu/menu_item.dart';
import 'package:apna_classroom_app/internationalization/strings.dart';
import 'package:apna_classroom_app/screens/media/widgets/video_playing_duration.dart';
import 'package:apna_classroom_app/theme/styles.dart';
import 'package:apna_classroom_app/util/date_time.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerOverlay extends StatelessWidget {
  final String title;
  final VideoPlayerController controller;
  final Function playPause;
  final Function overlaySwitch;

  const VideoPlayerOverlay(
      {Key key,
      this.controller,
      this.playPause,
      this.title,
      this.overlaySwitch})
      : super(key: key);

  // Forward 10 Second
  _forward10() async {
    controller.seekTo(
      Duration(seconds: controller.value.position.inSeconds + 10),
    );
  }

  // Move backward 10 seconds
  _replay10() {
    controller.seekTo(
      Duration(seconds: controller.value.position.inSeconds - 10),
    );
  }

  // Set Speed
  setSpeed(double speed) {
    controller.setPlaybackSpeed(speed);
    Get.back();
  }

  // Speed chooser
  _speedChoose() {
    Get.back();
    List<MenuItem> items = [
      MenuItem(
        iconData: Icons.slow_motion_video_rounded,
        onTap: () => setSpeed(0.50),
        text: '0.50',
      ),
      MenuItem(
        iconData: Icons.motion_photos_on_rounded,
        onTap: () => setSpeed(1.00),
        text: '1.00',
      ),
      MenuItem(
        iconData: Icons.fast_forward_rounded,
        onTap: () => setSpeed(1.50),
        text: '1.50',
      ),
      MenuItem(
        iconData: Icons.fast_forward_rounded,
        onTap: () => setSpeed(2.00),
        text: '2.00',
      ),
    ];
    showApnaMenu(Get.context, items, type: MenuType.BottomSheet);
  }

  // All Options
  _options() {
    List<MenuItem> items = [
      MenuItem(
          iconData: Icons.speed_rounded,
          onTap: _speedChoose,
          text: '${S.SPEED.tr} ( ${controller.value.playbackSpeed} )'),
      MenuItem(
        text: '${S.QUALITY.tr}',
        iconData: Icons.high_quality_rounded,
        onTap: () {},
      )
    ];
    showApnaMenu(Get.context, items, type: MenuType.BottomSheet);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48,
            ),
            onPressed: playPause,
          ),
        ),
        Positioned(
          top: 7,
          bottom: 0,
          right: 0,
          left: 200,
          child: Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.forward_10_rounded,
                color: Colors.white70,
                size: 42,
              ),
              onPressed: _forward10,
            ),
          ),
        ),
        Positioned(
          top: 7,
          bottom: 0,
          left: 0,
          right: 200,
          child: Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Icon(
                Icons.replay_10_rounded,
                color: Colors.white70,
                size: 42,
              ),
              onPressed: _replay10,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          left: 20,
          child: Row(
            children: [
              PlayingDuration(controller: controller),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: VideoProgressIndicator(
                      controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: primaryColor,
                        bufferedColor: Colors.white70,
                        backgroundColor: Colors.white30,
                      ),
                      padding: const EdgeInsets.only(),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(getReadableDuration(controller.value.duration)),
            ],
          ),
        ),
        Positioned(
          top: 4,
          right: 20,
          left: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 24),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => Get.back(),
                  ),
                  SizedBox(width: 24),
                  Text(
                    title ?? S.VIDEO.tr,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.settings_rounded),
                onPressed: _options,
              )
            ],
          ),
        ),
      ],
    );
  }
}
