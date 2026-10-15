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

const _edge = 40, _dip = 40;

class _HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) => Path()
    ..lineTo(0, size.height - _edge)
    ..quadraticBezierTo(
      size.width / 2,
      size.height - _edge + 2 * _dip,
      size.width,
      size.height - _edge,
    )
    ..lineTo(size.width, 0)
    ..close();

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
