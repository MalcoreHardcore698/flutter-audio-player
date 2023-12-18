import 'package:transparent_image/transparent_image.dart';
import 'package:flutter/material.dart';

const double _size = 260;

class AudioPlayerPreview extends StatelessWidget {
  const AudioPlayerPreview({
    super.key,
    this.name,
    required this.preview,
    this.width = _size,
    this.height = _size,
  });

  final String? name;
  final String preview;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: height,
          constraints: BoxConstraints(
            maxWidth: width ?? _size,
            maxHeight: height ?? _size,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(48)),
          ),
          clipBehavior: Clip.hardEdge,
          child: FadeInImage.memoryNetwork(
            image: preview,
            placeholder: kTransparentImage,
            fadeInDuration: const Duration(milliseconds: 150),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          name ?? 'Unknown Audio',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
