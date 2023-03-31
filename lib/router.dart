import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:surfify/features/authentication/policy_agreement_screen.dart';
import 'package:surfify/features/authentication/register_profile_screen.dart';
import 'package:surfify/features/initial_screen.dart';
import 'package:surfify/features/main_navigation/main_navigation_screen.dart';
import 'package:surfify/features/video/video_recording_screen.dart';

import 'features/authentication/repos/authentication_repo.dart';

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: MainNavigationScreen.routeName,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.subloc != InitialScreen.routeName) {
          return InitialScreen.routeName;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: "/",
        builder: (context, state) => const InitialScreen(),
      ),
      GoRoute(
        path: PolicyAgreementScreen.routeName,
        builder: (context, state) => const PolicyAgreementScreen(),
      ),
      GoRoute(
        path: RegisterProfileScreen.routeName,
        builder: (context, state) => const RegisterProfileScreen(),
      ),
      GoRoute(
        path: VideoRecordingScreen.routeName,
        builder: (context, state) => const VideoRecordingScreen(),
      ),
      GoRoute(
        path: MainNavigationScreen.routeName,
        builder: (context, state) => const MainNavigationScreen(),
      )
    ],
  );
});
