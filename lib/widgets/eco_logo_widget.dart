import 'package:flutter/material.dart';

class EcoLogoWidget extends StatelessWidget {
  final double size;

  const EcoLogoWidget({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _EcoLogoPainter(),
    );
  }
}

class _EcoLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle with soft border/background
    final bgPaint = Paint()
      ..color = const Color(0xFFE8F5E9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Green ring border
    final borderPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.055;
    canvas.drawCircle(center, radius - (size.width * 0.03), borderPaint);

    // White inner circular background
    final innerBgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - (size.width * 0.06), innerBgPaint);

    // Stylized cupped green hand at bottom
    final handPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;

    final handPath = Path();
    handPath.moveTo(size.width * 0.22, size.height * 0.68);
    handPath.cubicTo(
      size.width * 0.28, size.height * 0.82,
      size.width * 0.72, size.height * 0.82,
      size.width * 0.78, size.height * 0.68,
    );
    handPath.cubicTo(
      size.width * 0.70, size.height * 0.74,
      size.width * 0.30, size.height * 0.74,
      size.width * 0.22, size.height * 0.68,
    );
    handPath.close();
    canvas.drawPath(handPath, handPaint);

    // Tree trunk
    final trunkPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..strokeWidth = size.width * 0.06
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx, size.height * 0.68),
      Offset(center.dx, size.height * 0.44),
      trunkPaint,
    );

    // Foliage leaves (green)
    final leafPaint = Paint()
      ..color = const Color(0xFF388E3C)
      ..style = PaintingStyle.fill;

    final lightLeafPaint = Paint()
      ..color = const Color(0xFF66BB6A)
      ..style = PaintingStyle.fill;

    // Center main leaf
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, size.height * 0.32),
        width: size.width * 0.16,
        height: size.height * 0.22,
      ),
      leafPaint,
    );

    // Upper left leaf
    canvas.save();
    canvas.translate(size.width * 0.36, size.height * 0.38);
    canvas.rotate(-0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.13,
        height: size.height * 0.19,
      ),
      lightLeafPaint,
    );
    canvas.restore();

    // Upper right leaf
    canvas.save();
    canvas.translate(size.width * 0.64, size.height * 0.38);
    canvas.rotate(0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.13,
        height: size.height * 0.19,
      ),
      lightLeafPaint,
    );
    canvas.restore();

    // Lower left leaf
    canvas.save();
    canvas.translate(size.width * 0.28, size.height * 0.50);
    canvas.rotate(-0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.11,
        height: size.height * 0.16,
      ),
      leafPaint,
    );
    canvas.restore();

    // Lower right leaf
    canvas.save();
    canvas.translate(size.width * 0.72, size.height * 0.50);
    canvas.rotate(0.9);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.11,
        height: size.height * 0.16,
      ),
      leafPaint,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
