import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/utils/position_data.dart';
import 'package:audio_player/widgets/audio_player/audio_player_controls.dart';
import 'package:audio_player/widgets/base/base_seek_bar.dart';

class AudioPlayerTimeline extends StatelessWidget {
  const AudioPlayerTimeline({
    super.key,
    required this.player,
    required this.stream,
    this.isFavorite = false,
    this.onLike,
    this.onPlay,
    this.onPause,
    this.onRepeat,
    this.onDownload,
    this.onRewind,
  });

  final AudioPlayer player;
  final Stream<PositionData> stream;
  final bool isFavorite;
  final void Function()? onLike;
  final void Function()? onPlay;
  final void Function()? onPause;
  final void Function()? onRepeat;
  final void Function()? onDownload;
  final void Function()? onRewind;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: stream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        final duration = positionData?.duration ?? Duration.zero;
        final position = positionData?.position ?? Duration.zero;

        final bufferedPosition = positionData?.bufferedPosition ?? Duration.zero;

        return Column(
          children: [
            BaseSeekBar(
              duration: duration,
              position: position,
              bufferedPosition: bufferedPosition,
              onChangeEnd: player.seek,
            ),
            const SizedBox(height: 36),
            // Player Actions
            Expanded(
              child: AudioPlayerControls(
                player: player,
                duration: duration,
                isFavorite: isFavorite,
                onLike: onLike,
                onPlay: onPlay,
                onPause: onPause,
                onRepeat: onRepeat,
                onDownload: onDownload,
                onRewind: onRewind,
              ),
            ),
          ],
        );
      },
    );
  }
}
