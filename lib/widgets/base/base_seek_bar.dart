import 'dart:math';

import 'package:flutter/material.dart';

class BaseSeekBar extends StatefulWidget {
  const BaseSeekBar({
    super.key,
    required this.duration,
    required this.position,
    required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  @override
  State<BaseSeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<BaseSeekBar> {
  double? _dragValue;

  String _formatDuration(Duration duration) {
    const String pattern = r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$';
    final String? result = RegExp(pattern).firstMatch('$duration')?.group(1);
    return result ?? '$duration';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          child: Stack(
            children: [
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 0.5,
                  trackShape: const RoundedRectSliderTrackShape(),
                  activeTrackColor: Colors.white.withOpacity(0.4),
                  inactiveTrackColor: Colors.white.withOpacity(0.4),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                ),
                child: ExcludeSemantics(
                  child: Slider(
                    min: 0.0,
                    max: widget.duration.inMilliseconds.toDouble(),
                    value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                      widget.duration.inMilliseconds.toDouble(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _dragValue = value;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(Duration(milliseconds: value.round()));
                      }
                    },
                    onChangeEnd: (value) {
                      if (widget.onChangeEnd != null) {
                        widget.onChangeEnd!(Duration(milliseconds: value.round()));
                      }
                      _dragValue = null;
                    },
                  ),
                ),
              ),
              SliderTheme(
                data: SliderThemeData(
                  trackHeight: 0.5,
                  trackShape: const RoundedRectSliderTrackShape(),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.4),
                ),
                child: Slider(
                  min: 0.0,
                  max: widget.duration.inMilliseconds.toDouble(),
                  value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                    widget.duration.inMilliseconds.toDouble()
                  ),
                  thumbColor: Colors.white,
                  overlayColor: MaterialStateColor.resolveWith(
                    (states) => Colors.transparent,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _dragValue = value;
                    });
                    if (widget.onChanged != null) {
                      widget.onChanged!(Duration(milliseconds: value.round()));
                    }
                  },
                  onChangeEnd: (value) {
                    if (widget.onChangeEnd != null) {
                      widget.onChangeEnd!(Duration(milliseconds: value.round()));
                    }
                    _dragValue = null;
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formatDuration(widget.position),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14,
                ),
              ),
              Text(
                _formatDuration(widget.duration),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
