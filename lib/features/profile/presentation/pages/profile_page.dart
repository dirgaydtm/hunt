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
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final uploading = ref.watch(profileControllerProvider);

    void showError(String? error) {
      if (error == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.redNormal),
      );
    }

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
                alignment: Alignment(0, -0.2),
                child: Text(
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
              offset: Offset(0, -50),
              child: Column(
                children: [
                  _Avatar(
                    imageUrl: user.avatarUrl,
                    uploading: uploading,
                    onEdit: () async => showError(
                      await ref
                          .read(profileControllerProvider.notifier)
                          .pickAndUploadAvatar(),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 18,
                      fontWeight: AppFontWeight.bold,
                      color: AppColors.blueDarkActive,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    user.university ?? 'Universitas belum diisi',
                    style: TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 14,
                      color: AppColors.blueDark,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: .center,
                    children: [
                      _CircleIconButton(
                        icon: Icons.notifications,
                        onTap: () => context.push('/notifications'),
                      ),
                      SizedBox(width: 16),
                      _CircleIconButton(icon: Icons.bookmark_border),
                      if (user.isAdmin) ...[
                        SizedBox(width: 16),
                        _CircleIconButton(
                          icon: Icons.admin_panel_settings_outlined,
                          onTap: () => context.push('/admin'),
                        ),
                      ],
                    ],
                  ),
                  SizedBox(height: 32),
                  HuntAccordion(
                    title: user.email,
                    leadingIcon: Icons.mail_outline,
                    items: [],
                  ),
                  HuntAccordion(
                    title: user.university ?? 'Universitas belum diisi',
                    leadingIcon: Icons.account_balance,
                    items: [],
                  ),
                  HuntAccordion(
                    title: user.major ?? 'Jurusan belum diisi',
                    leadingIcon: Icons.work_outline,
                    items: [],
                  ),
                  HuntAccordion(
                    title:
                        user.graduationYear?.toString() ??
                        'Tahun lulus belum diisi',
                    leadingIcon: Icons.calendar_today_outlined,
                    items: [],
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.blueLightActive.withValues(alpha: 0.5),
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: .symmetric(horizontal: 46),
                    child: Row(
                      children: [
                        Expanded(
                          child: HuntButton(
                            text: 'Logout',
                            leading: Icon(
                              Icons.logout,
                              size: 18,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              await ref.read(authProvider.notifier).logout();
                              if (context.mounted) context.go('/login');
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: HuntButton(
                            text: 'Edit Profile',
                            isOutlined: true,
                            leading: Icon(
                              Icons.edit,
                              size: 18,
                              color: AppColors.blueNormalActive,
                            ),
                            onPressed: () => context.push('/profile/edit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
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
  const _Avatar({
    required this.imageUrl,
    required this.uploading,
    required this.onEdit,
  });
  final String? imageUrl;
  final bool uploading;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: .none,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: .circle,
            color: AppColors.blueLightActive,
            border: .all(color: Colors.white, width: 4),
            image: imageUrl != null
                ? DecorationImage(image: NetworkImage(imageUrl!), fit: .cover)
                : null,
          ),
          child: uploading
              ? Center(child: CircularProgressIndicator())
              : imageUrl == null
              ? Icon(Icons.person, size: 50, color: AppColors.blueDark)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: uploading ? null : onEdit,
            child: Container(
              padding: .all(6),
              decoration: BoxDecoration(
                color: Color(0xFFFBF4D8),
                shape: .circle,
              ),
              child: Icon(
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
  const _CircleIconButton({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: CircleBorder(),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: AppColors.blueNormal, shape: .circle),
        child: Icon(icon, color: Colors.white),
      ),
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
