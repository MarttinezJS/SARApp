import 'package:flutter/material.dart';

class Background extends StatelessWidget {

  final Color color;

  const Background({
    Key key,
    @required this.color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.black,
      child: CustomPaint(
        painter: _BackgroundPainter(color),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {

  Color color;

  _BackgroundPainter(
    this.color
  );

  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint();

    paint.color = color;
    // paint.color = Color.fromRGBO(255, 190, 36, 1);
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 2;

    final path = Path();

    path.lineTo(0, size.height * 0.25);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.5, size.width * 0.25 , size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.width * 0.75, size.width , size.height * 0.3);
    path.lineTo(size.width, 0);

    path.moveTo(size.width, size.height * 0.4);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.45, size.width * 0.33, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.6, size.height * 0.85, size.width , size.height * 0.95);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BackgroundPainter oldDelegate) => true;

}