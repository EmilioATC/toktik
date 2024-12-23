import 'package:flutter/material.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:toktik/presentation/widgets/video/video_background.dart';
import 'package:video_player/video_player.dart';

class FullScreenPlayer extends StatefulWidget {
  final String videoUrl;
  final String caption;

  const FullScreenPlayer(
      {super.key, required this.videoUrl, required this.caption});

  @override
  State<FullScreenPlayer> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.videoUrl)
      // ..setVolume(0)
      ..setLooping(true)
      ..play();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        return GestureDetector(
          
          onTap: () {
            if (controller.value.isPlaying) {
              controller.pause();
              return;
            }

            controller.play();
          },
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              children: [
                VideoPlayer(controller),

                // Gradiente
                VideoBackground(
                  stops: const [0.8, 1.0],
                ),

                // Texto
                Positioned(
                    bottom: 50,
                    left: 20,
                    child: _VideoCaption(caption: widget.caption)),

                Positioned(
                    bottom: 50,
                    left: 20,
                    child: _VideoCaption(caption: widget.caption)),

                

                if (controller.value.isInitialized)
                  Positioned(
                    bottom: 4,
                    left: 10,
                    right: 10,
                    child: SmoothVideoProgress(controller: controller, builder: (context, position, duration, _)  => 
                    _VideoProgressSlider(
                      position: position,
                      duration: duration, 
                      controller: controller,
                      size: 2,),),
                  ),
              ],
            ),
          ),
        ); 
      },
    );
  }
}

class _VideoCaption extends StatelessWidget {
  final String caption;

  const _VideoCaption({required this.caption});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final titleStyle = Theme.of(context).textTheme.titleLarge;

    return SizedBox(
      width: size.width * 0.6,
      child: Text(caption, maxLines: 2, style: titleStyle),
    );
  }
}

class _VideoProgressSlider extends StatelessWidget {
  const _VideoProgressSlider({
    required this.position,
    required this.duration,
    required this.controller,
    required this.size,
  });

  final Duration position;
  final Duration duration;
  final VideoPlayerController controller;
  final double size;

  @override
  Widget build(BuildContext context) {
    final max = duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, max).toDouble();
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbColor: Colors.transparent,
        overlayColor: Colors.transparent,
        activeTrackColor: const Color.fromARGB(133, 211, 211, 211),
        trackHeight: size,    
      ),
      child: Slider(
          min: 0,
          max: max,
          value: value,
          onChanged: (value) =>
              controller.seekTo(Duration(milliseconds: value.toInt())),
          onChangeStart: (_) => controller.pause(),
          onChangeEnd: (_) => controller.play(),
        ),
    );
  }
}