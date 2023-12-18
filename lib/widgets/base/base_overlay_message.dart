import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'package:audio_player/models/model_audio.dart';
import 'package:audio_player/widgets/audio_player/audio_player.dart';

class ScreenAudioPlayer extends StatefulWidget {
  const ScreenAudioPlayer({
    super.key,
    required this.audio,
  });

  final ModelAudio audio;

  @override
  State<ScreenAudioPlayer> createState() => _State();
}

class _State extends State<ScreenAudioPlayer> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    super.initState();
  }

  Future<void> _createOverlay(BuildContext context) async {
    _removeOverlay();

    assert(_overlayEntry == null);

    OverlayState overlayState = Overlay.of(context);

    final Widget content = Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 48,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(24, 25, 25, 0.80),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 8),
            Text(
              'Added to favorites',
              style: TextStyle(
                color: Colors.white,
                decorationThickness: 0,
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );

    _overlayEntry = OverlayEntry(
      builder: (_) => Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.15,
          ),
          child: FadeTransition(
            opacity: _animationController,
            child: content,
          ),
        ),
      ),
    );

    _animationController.addListener(() {
      overlayState.setState(() {});
    });
    _animationController.forward();

    overlayState.insert(_overlayEntry!);
    await Future.delayed(const Duration(seconds: 2));
    _animationController.reverse();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    // Make sure to remove OverlayEntry when the widget is disposed.
    _removeOverlay();

    _animationController.dispose();
    _animationController.removeListener(() {
      setState(() {});
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomAudioPlayer(
            url: widget.audio.url,
            name: widget.audio.title,
            preview: widget.audio.preview,
            onLike: () {
              _createOverlay(context);
            },
            onDelete: () {},
            onBack: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
