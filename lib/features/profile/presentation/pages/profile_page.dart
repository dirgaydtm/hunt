import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/hunt_accordion.dart';
import '../../../../shared/widgets/hunt_button.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

TextStyle _ts(double size, FontWeight? weight, Color color) => TextStyle(
  fontFamily: AppTextStyles.fontFamily,
  fontSize: size,
  fontWeight: weight,
  color: color,
);

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    if (user == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final university = user.university ?? 'Universitas belum diisi';
    final info = [
      (Icons.mail_outline, user.email),
      // Student details don't apply to admins.
      if (!user.isAdmin) ...[
        (Icons.account_balance, university),
        (Icons.work_outline, user.major ?? 'Jurusan belum diisi'),
        (
          Icons.calendar_today_outlined,
          user.graduationYear?.toString() ?? 'Tahun lulus belum diisi',
        ),
      ],
    ];

    Future<void> changeAvatar() async {
      final error = await ref
          .read(profileControllerProvider.notifier)
          .pickAndUploadAvatar();
      if (error == null || !context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.redNormal),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 190,
              child: ClipPath(
                clipper: _ProfileHeaderClipper(),
                child: Container(
                  color: AppColors.blueNormal,
                  alignment: Alignment(0, -0.2),
                  child: Text(
                    'Profile',
                    style: _ts(
                      20,
                      AppFontWeight.extraBold,
                      AppColors.blueDarkActive,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -50),
              child: Column(
                spacing: 12,
                children: [
                  _Avatar(
                    imageUrl: user.avatarUrl,
                    uploading: ref.watch(profileControllerProvider),
                    onEdit: changeAvatar,
                  ),
                  Text(
                    user.name,
                    style: _ts(
                      18,
                      AppFontWeight.bold,
                      AppColors.blueDarkActive,
                    ),
                  ),
                  if (!user.isAdmin)
                    Text(university, style: _ts(14, null, AppColors.blueDark)),
                  Row(
                    mainAxisAlignment: .center,
                    spacing: 16,
                    children: [
                      _circleButton(
                        Icons.notifications,
                        () => context.push('/notifications'),
                      ),
                      if (user.isAdmin)
                        _circleButton(
                          Icons.admin_panel_settings_outlined,
                          () => context.push('/admin'),
                        ),
                    ],
                  ),
                  Column(
                    children: [
                      for (final (icon, title) in info)
                        HuntAccordion(
                          title: title,
                          leadingIcon: icon,
                          items: [],
                          horizontalPadding: 16,
                        ),
                      Divider(
                        height: 1,
                        color: AppColors.blueLightActive.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                  Padding(
                    padding: .symmetric(horizontal: 32, vertical: 28),
                    child: Row(
                      spacing: 16,
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
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFFBF4D8),
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

Widget _circleButton(IconData icon, VoidCallback onTap) => IconButton.filled(
  onPressed: onTap,
  icon: Icon(icon),
  style: IconButton.styleFrom(
    backgroundColor: AppColors.blueNormal,
    fixedSize: Size.square(48),
  ),
);

class _ProfileHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) =>
      (Path()
            ..lineTo(440, 0)
            ..lineTo(440, 253.264)
            ..cubicTo(440, 253.264, 306.555, 287.133, 218.872, 287)
            ..cubicTo(132.056, 286.867, 0, 253.264, 0, 253.264)
            ..close())
          .transform(
            Matrix4.diagonal3Values(
              size.width / 440,
              size.height / 287,
              1,
            ).storage,
          );

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
