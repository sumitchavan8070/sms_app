import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_management/attendance_module/view/change_password.dart';
import 'package:school_management/attendance_module/view/grp_chat.dart';
import 'package:school_management/attendance_module/view/leave_management_screen.dart';
import 'package:school_management/attendance_module/view/mark_class_attendance.dart';
import 'package:school_management/attendance_module/view/client_attendance_view.dart';
import 'package:school_management/authentication_module/view/profile_view.dart';
import 'package:school_management/authentication_module/view/sign_in_view.dart';
import 'package:school_management/authentication_module/view/test_screen.dart';
import 'package:school_management/constants.dart';
import 'package:school_management/payments/razorpay.dart';
import 'package:school_management/screens/entryPoint/landing_view.dart';
import 'package:school_management/screens/home/home_screen.dart';
import 'package:school_management/screens/onboding/onboding_screen.dart';
import 'package:school_management/utils/constants/core_prep_paths.dart';
import 'package:school_management/utils/navigation/go_paths.dart';
import 'package:school_management/utils/services/core_navigation_observer.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter goRouterConfig = GoRouter(
  initialLocation: GoPaths.splash,
  navigatorKey: rootNavigatorKey,

  redirect: (context, state) {
    final bool isLoggedIn = corePrefs.read(CorePrepPaths.isLoggedIn) == true;

    final bool goingToOnboarding = state.matchedLocation == GoPaths.onboarding;
    final bool goingToSplash = state.matchedLocation == GoPaths.splash;

    // User NOT logged in → go to onboarding
    // if (!isLoggedIn) {
    //   if (!goingToOnboarding) return GoPaths.onBoarding;
    //   return null;
    // }
    // User logged in → block onboarding/splash
    if (isLoggedIn && (goingToOnboarding || goingToSplash)) {
      return GoPaths.landingView;
    }

    return null;
  },

  observers: [CoreNavigationObserver()],

  routes: [
    // Splash
    // GoRoute(
    //   parentNavigatorKey: rootNavigatorKey,
    //   path: GoPaths.splash,
    //   name: GoPaths.splash,
    //   builder: (context, state) {
    //     return const OnbodingScreen(); // if you want a real splash, change this
    //   },
    // ),

    // Splash
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.splash,
      name: GoPaths.splash,
      builder: (context, state) {
        return const AuthScreen(); // if you want a real splash, change this
      },
    ),

    // Onboarding
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.onboarding,
      name: GoPaths.onboarding,
      builder: (context, state) {
        return const OnbodingScreen();
      },
    ),

    // Home / Landing page
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.landingView,
      name: GoPaths.landingView,
      builder: (context, state) => LandingView(),
    ),

    // Login
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.signIn,
      name: GoPaths.signIn,
      builder: (context, state) => SignInScreen(),
    ),

    // Profile view
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.profile,
      name: GoPaths.profile,
      builder: (context, state) => ProfileView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.userAttendanceView,
      name: GoPaths.userAttendanceView,
      builder: (context, state) => ClientAttendanceView(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.leaveManagement,
      name: GoPaths.leaveManagement,
      builder: (context, state) => LeaveManagementScreen(),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.changePassword,
      name: GoPaths.changePassword,
      builder: (context, state) => ChangePasswordView(),
    ),


    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.attendanceManagement,
      name: GoPaths.attendanceManagement,
      builder: (context, state) => AttendanceManagementScreen(),
    ),

    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.groupChat,
      name: GoPaths.groupChat,
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        final grpId = extras["grpId"] as String;

        return GroupChatScreen(groupId: grpId);
      },
    ),


    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: GoPaths.razorPayPayment,
      name: GoPaths.razorPayPayment,
      builder: (context, state) {


        return RazorPayPaymentScreen();
      },
    ),
  ],
);
