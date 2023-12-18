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

  bool isFavorite = false;

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

  Future<void> _createOverlay({
    required BuildContext context,
    double width = 200,
    double height = 48,
    required Widget child,
  }) async {
    _removeOverlay();

    assert(_overlayEntry == null);

    OverlayState overlayState = Overlay.of(context);

    final Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(24, 25, 25, 0.80),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: child,
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

  void _showDownloadOverlay(BuildContext context) {
    _createOverlay(
      context: context,
      child: const Center(
        child: Text(
        'Скачивание началось',
        style: TextStyle(
          color: Colors.white,
          decorationThickness: 0,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      ),
    );
  }

  void _showFavoriteOverlay(BuildContext context) {
    _createOverlay(
      context: context,
      width: MediaQuery.of(context).size.width * 0.75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isFavorite ? Icons.favorite_outline_rounded : Icons.favorite_rounded,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            isFavorite ? 'Убрано из избранного' : 'Добавлено в избранное',
            style: const TextStyle(
              color: Colors.white,
              decorationThickness: 0,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteOverlay(BuildContext context) {
    _createOverlay(
      context: context,
      width: MediaQuery.of(context).size.width * 0.65,
      child: const Center(
        child: Text(
        'Удалено из билиотеки',
        style: TextStyle(
          color: Colors.white,
          decorationThickness: 0,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
      ),
      ),
    );
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
            isFavorite: isFavorite,
            onLike: () {
              setState(() {
                isFavorite = !isFavorite;
              });
              _showFavoriteOverlay(context);
            },
            onDownload: () {
              _showDownloadOverlay(context);
            },
            onDelete: () {
              _showDeleteOverlay(context);
            },
            onBack: () {
              context.go('/');
            },
          ),
        ],
      ),
    );
  }
}
