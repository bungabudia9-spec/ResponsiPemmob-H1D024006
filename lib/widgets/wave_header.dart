import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WaveHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 35);

    final firstControlPoint = Offset(size.width * 0.25, size.height);
    final firstEndPoint = Offset(size.width * 0.5, size.height - 20);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.75, size.height - 40);
    final secondEndPoint = Offset(size.width, size.height - 15);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SecondaryWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 15);

    final firstControlPoint = Offset(size.width * 0.35, size.height - 45);
    final firstEndPoint = Offset(size.width * 0.7, size.height - 10);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secondControlPoint = Offset(size.width * 0.88, size.height + 10);
    final secondEndPoint = Offset(size.width, size.height - 25);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class WaveHeader extends StatelessWidget {
  final Widget child;
  final double height;

  const WaveHeader({
    super.key,
    required this.child,
    this.height = 360,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          // Gelombang Lapisan Latar Belakang (Sky Blue / Navy Blend)
          ClipPath(
            clipper: SecondaryWaveClipper(),
            child: Container(
              height: height,
              color: AppTheme.skyBlue.withValues(alpha: 0.5),
            ),
          ),
          // Gelombang Utama (Navy Gradient)
          ClipPath(
            clipper: WaveHeaderClipper(),
            child: Container(
              height: height - 12,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.deepNavy, AppTheme.navyBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
