const _publicRoutes = {'/', '/login', '/register', '/forgot-password'};

/// Pure routing decision so it can be unit-tested without a router.
/// Returns the path to redirect to, or null to stay.
String? authRedirect({
  required String location,
  required bool loggedIn,
  required bool onboardingSeen,
  required bool recoveringPassword,
  required bool isAdmin,
  required bool profileLoading,
}) {
  final isPublic = _publicRoutes.contains(location);

  if (!loggedIn) {
    if (location == '/' && onboardingSeen) return '/login';
    return isPublic ? null : '/login';
  }

  if (recoveringPassword) {
    return location == '/reset-password' ? null : '/reset-password';
  }
  if (isPublic || location == '/reset-password') return '/home';

  if (location.startsWith('/admin') && !isAdmin && !profileLoading) {
    return '/home';
  }
  return null;
}
