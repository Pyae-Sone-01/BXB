import 'package:flutter/material.dart';

class VistoryBtnWidget extends StatefulWidget {
  const VistoryBtnWidget({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<VistoryBtnWidget> createState() => _VistoryBtnWidgetState();
}

class _VistoryBtnWidgetState extends State<VistoryBtnWidget>
    with TickerProviderStateMixin {
  late AnimationController _borderGlowController;
  late AnimationController _sparkleController;
  late AnimationController _textShimmerController;

  @override
  void initState() {
    super.initState();
    _borderGlowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _textShimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _borderGlowController.dispose();
    _sparkleController.dispose();
    _textShimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _borderGlowController,
        builder: (context, _) {
          final glowValue = _borderGlowController.value;

          return Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFBD786),
                  Color(0xFFFB7BA2),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.amberAccent.withOpacity(0.5 + glowValue * 0.3),
                  blurRadius: 10 + glowValue * 15,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildTextShimmer(),
                Positioned(
                  bottom: -2,
                  child: Opacity(
                      opacity: 0.5, child: _buildSparkleColumn(delay: 0.2)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextShimmer() {
    return AnimatedBuilder(
      animation: _textShimmerController,
      builder: (context, _) {
        final shimmerValue = (0.7 + 0.3 * _textShimmerController.value);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.share, color: Colors.white, size: 22),
            const SizedBox(width: 8),
            Text(
              "Share My Victory 🎉",
              style: TextStyle(
                color: Colors.white.withOpacity(shimmerValue),
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 1,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSparkleColumn({required double delay}) {
    return AnimatedBuilder(
      animation: _sparkleController,
      builder: (context, _) {
        final t = (_sparkleController.value + delay) % 1.0;
        final offset = (t * 6) - 3;
        final opacity = 0.5 + (t * 0.5);
        final scale = 1 + (0.3 * t);

        return Transform.translate(
          offset: Offset(0, -offset),
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text("✨", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 2),
                  Text("🌟", style: TextStyle(fontSize: 16)),
                  SizedBox(height: 2),
                  Text("💫", style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
