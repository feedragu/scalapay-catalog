import 'package:flutter/material.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_palette.dart';
import 'package:scalapay_catalog/core/design_system/foundations/app_sizes.dart';

class AppRadio extends StatelessWidget {
  const AppRadio({required this.selected, super.key});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return CustomPaint(
      size: const Size.square(AppSizes.radio),
      painter: _RadioPainter(
        color: selected
            ? palette.lilac900
            : palette.buttonsLightweightLilacHover,
        filled: selected,
      ),
    );
  }
}

class _RadioPainter extends CustomPainter {
  const _RadioPainter({required this.color, required this.filled});

  final Color color;
  final bool filled;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final scale = size.width / AppSizes.radio;
    // Figma: 20px ring with a 2px stroke around a 10px dot, in a 24px box.
    canvas.drawCircle(
      center,
      9 * scale,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale,
    );
    if (filled) {
      canvas.drawCircle(center, 5 * scale, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_RadioPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.filled != filled;
}
