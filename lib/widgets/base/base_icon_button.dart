import 'package:flutter/material.dart';

class BaseIconButton extends StatelessWidget {
  const BaseIconButton({
    super.key,
    this.icon,
    this.child,
    this.width = 40,
    this.height = 40,
    this.background,
    this.onPressed,
  });

  final IconData? icon;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? background;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget content =
        Icon(icon, color: Colors.white, size: 24);

    if (child != null) {
      content = child!;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: background ?? Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(48),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(48),
        child: content,
      ),
    );
  }
}
