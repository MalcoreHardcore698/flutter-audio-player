import 'dart:developer';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'package:audio_player/utils/position_data.dart';
import 'package:audio_player/widgets/audio_player/audio_player_preview.dart';
import 'package:audio_player/widgets/audio_player/audio_player_timeline.dart';

class CustomAudioPlayer extends StatefulWidget {
  const CustomAudioPlayer({
    super.key,
    this.name,
    required this.url,
    required this.preview,
    this.width,
    this.height,
    this.isFavorite = false,
    this.onLike,
    this.onPlay,
    this.onPause,
    this.onRepeat,
    this.onDownload,
    this.onDelete,
    this.onRewind,
    this.onBack,
  });

  final String? name;
  final String url;
  final String preview;
  final double? width;
  final double? height;
  final bool isFavorite;
  final void Function()? onLike;
  final void Function()? onPlay;
  final void Function()? onPause;
  final void Function()? onRepeat;
  final void Function()? onDownload;
  final void Function()? onDelete;
  final void Function()? onRewind;
  final void Function()? onBack;

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _initAudio();
  }

  Future<void> _initAudio() async {
    final session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration.speech());

    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
      onError: (Object e, StackTrace stackTrace) {
        log('A stream error occurred: $e');
      },
    );

    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(widget.url)));
    } catch (e) {
      log("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  Stream<PositionData> get _positionDataStream =>
    Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FadeInImage.memoryNetwork(
            image: widget.preview,
            placeholder: kTransparentImage,
            fadeInDuration: const Duration(milliseconds: 150),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            ),
          ),
        ),
        Positioned(
          top: 42,
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 5,
                  child: AudioPlayerPreview(
                    name: widget.name,
                    preview: widget.preview,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: AudioPlayerTimeline(
                    stream: _positionDataStream,
                    player: _player,
                    isFavorite: widget.isFavorite,
                    onLike: widget.onLike,
                    onPlay: widget.onPlay,
                    onPause: widget.onPause,
                    onRepeat: widget.onRepeat,
                    onDownload: widget.onDownload,
                    onRewind: widget.onRewind,
                  ),
                ),
                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
