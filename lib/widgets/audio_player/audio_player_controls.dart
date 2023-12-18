import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/widgets/base/base_icon_button.dart';

class AudioPlayerControls extends StatelessWidget {
  const AudioPlayerControls({
    super.key,
    required this.player,
    required this.duration,
    this.isFavorite = false,
    this.onLike,
    this.onPlay,
    this.onPause,
    this.onRepeat,
    this.onDownload,
    this.onRewind,
  });

  final AudioPlayer player;
  final Duration duration;
  final bool isFavorite;
  final void Function()? onLike;
  final void Function()? onPlay;
  final void Function()? onPause;
  final void Function()? onRepeat;
  final void Function()? onDownload;
  final void Function()? onRewind;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite_outline_rounded : Icons.favorite_rounded,
            color: Colors.white,
            size: 24,
          ),
          onPressed: onLike,
        ),
        Expanded(
          child: StreamBuilder<PlayerState>(
            stream: player.playerStateStream,
            builder: (context, snapshot) {
              final playerState = snapshot.data;
              final processingState = playerState?.processingState;
              final playing = playerState?.playing;
        
              const Widget placeholder = SizedBox(
                width: 56,
                height: 56,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
        
              Widget middle = BaseIconButton(
                width: 56,
                height: 56,
                background: Colors.transparent,
                child: SvgPicture.asset('assets/images/ic_subtract.svg'),
                onPressed: () async {
                  if (onPlay != null) {
                    onPlay!();
                  }
                  await player.play();
                },
              );
        
              if (playing != true) {
                middle = BaseIconButton(
                  width: 56,
                  height: 56,
                  background: Colors.transparent,
                  child: SvgPicture.asset('assets/images/ic_subtract.svg'),
                  onPressed: () async {
                    if (onPlay != null) {
                      onPlay!();
                    }
                    await player.play();
                  },
                );
              }
        
              if (playing == true && processingState != ProcessingState.completed) {
                middle = BaseIconButton(
                  width: 56,
                  height: 56,
                  background: Colors.transparent,
                  child: SvgPicture.asset('assets/images/ic_pause.svg'),
                  onPressed: () async {
                    if (onPause != null) {
                      onPause!();
                    }
                    await player.pause();
                  },
                );
              }
        
              final bool isLoading = processingState == ProcessingState.loading;
              final bool isBuffering = processingState == ProcessingState.buffering;
              if (isLoading || isBuffering) {
                middle = placeholder;
              }
        
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BaseIconButton(
                    icon: Icons.repeat_rounded,
                    onPressed: onRepeat,
                  ),
                  middle,
                  BaseIconButton(
                    icon: Icons.skip_next_rounded,
                    onPressed: () async {
                      if (onRewind != null) {
                        onRewind!();
                      }
                      await player.seek(Duration(seconds: duration.inSeconds));
                    },
                  ),
                ],
              );
            },
          ),
        ),
        IconButton(
          onPressed: () {
            if (onDownload != null) {
              onDownload!();
            }
          },
          icon: const Icon(
            Icons.download_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
