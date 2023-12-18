import 'package:audio_player/models/model_audio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:audio_player/screens/screen_audio_player.dart';
import 'package:audio_player/screens/screen_library.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ScreenLibrary(),
    ),
    GoRoute(
      path: '/audio-player',
      builder: (context, state) {
        final audio = state.extra as ModelAudio;
        return ScreenAudioPlayer(audio: audio);
      },
    ),
  ],
);
