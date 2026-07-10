import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final double? height;

  const AuthHeader({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderCurveClipper(),
      child: Container(
        height: height ?? MediaQuery.of(context).size.height * 0.40,
        color: AppColors.blueNormal,
      ),
    );
  }
}

class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 80,
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
