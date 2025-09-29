import 'dart:ui';

import 'package:flutter/material.dart';

class BackgroundStackWidget extends StatelessWidget {
  final Widget child;
  const BackgroundStackWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1846C7),
          ),
        ),
        // Blurred circles
        Positioned(
          top: 80,
          left: 30,
          child: _BlurCircle(120, Colors.white.withOpacity(0.15)),
        ),
        Positioned(
          top: 220,
          right: 40,
          child: _BlurCircle(100, Colors.white.withOpacity(0.12)),
        ),
        Positioned(
          bottom: 120,
          left: 40,
          child: _BlurCircle(80, Colors.white.withOpacity(0.10)),
        ),
        Positioned(
          bottom: 60,
          right: 60,
          child: _BlurCircle(70, Colors.white.withOpacity(0.10)),
        ),
        child
        // Main content
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _BlurCircle(this.size, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
