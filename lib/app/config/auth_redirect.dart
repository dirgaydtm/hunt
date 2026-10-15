const _publicRoutes = {'/', '/login', '/register'};

/// Pure routing decision so it can be unit-tested without a router.
/// Returns the path to redirect to, or null to stay.
String? authRedirect({
  required String location,
  required bool loggedIn,
  required bool onboardingSeen,
  required bool isAdmin,
  required bool profileLoading,
}) {
  final isPublic = _publicRoutes.contains(location);

  if (!loggedIn) {
    if (location == '/' && onboardingSeen) return '/login';
    return isPublic ? null : '/login';
  }

  if (isPublic) return '/home';

  if (location.startsWith('/admin') && !isAdmin && !profileLoading) {
    return '/home';
  }
  if (location.startsWith('/bookmark') && isAdmin) return '/home';
  return null;
}
