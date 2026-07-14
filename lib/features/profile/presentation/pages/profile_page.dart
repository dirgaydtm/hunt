import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_accordion.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final imagePath = ref.watch(profileImageProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: _ProfileHeaderClipper(),
              child: Container(
                width: double.infinity,
                height: 220,
                color: AppColors.blueNormal,
                alignment: const Alignment(0, -0.2),
                child: const Text(
                  'Profile',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 20,
                    fontWeight: AppFontWeight.extraBold,
                    color: AppColors.blueDarkActive,
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -50),
              child: Column(
                children: [
                  _Avatar(
                    imagePath: imagePath,
                    onEdit: () =>
                        ref.read(profileImageProvider.notifier).pickImage(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarkActive,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.university,
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.blueDark,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleIconButton(icon: Icons.notifications),
                      const SizedBox(width: 16),
                      _CircleIconButton(icon: Icons.bookmark_border),
                    ],
                  ),
                  const SizedBox(height: 32),
                  HuntAccordion(
                    title: user.email,
                    leadingIcon: Icons.mail_outline,
                    items: const [],
                  ),
                  HuntAccordion(
                    title: user.university,
                    leadingIcon: Icons.account_balance,
                    items: const [],
                  ),
                  HuntAccordion(
                    title: user.major,
                    leadingIcon: Icons.work_outline,
                    items: const [],
                  ),
                  HuntAccordion(
                    title: user.graduationYear,
                    leadingIcon: Icons.calendar_today_outlined,
                    items: const [],
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.blueLightActive.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 46),
                    child: Row(
                      children: [
                        Expanded(
                          child: HuntButton(
                            text: 'Logout',
                            leading: const Icon(
                              Icons.logout,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              ref.read(authProvider.notifier).logout();
                              context.go('/login');
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: HuntButton(
                            text: 'Edit Profile',
                            isOutlined: true,
                            leading: const Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.blueNormalActive,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.imagePath, required this.onEdit});
  final String? imagePath;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.blueLightActive,
            border: Border.all(color: Colors.white, width: 4),
            image: imagePath != null
                ? DecorationImage(
                    image: FileImage(File(imagePath!)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imagePath == null
              ? const Icon(Icons.person, size: 50, color: AppColors.blueDark)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF4D8),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                size: 16,
                color: AppColors.greyDarkNormalActive,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.blueNormal,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class _ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height - 60)
      ..quadraticBezierTo(
        size.width * .5,
        size.height + 40,
        size.width,
        size.height - 60,
      )
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
