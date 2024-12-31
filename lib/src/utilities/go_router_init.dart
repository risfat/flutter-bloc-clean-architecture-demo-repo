import 'package:bloc_clean_architecture/src/common/routes.dart';
import 'package:bloc_clean_architecture/src/features/github/presentation/screens/github_repos_screen.dart';
import 'package:bloc_clean_architecture/src/features/splash/presentation/splash_screen.dart';
import 'package:bloc_clean_architecture/src/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../common/screens/error_screen.dart';

GoRouter routerInit = GoRouter(
  routes: <RouteBase>[
    ///  =================================================================
    ///  ********************** Splash Route *****************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.SPLASH_ROUTE_NAME,
      path: AppRoutes.SPLASH_ROUTE_PATH,
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    ///  =================================================================
    ///  ******************** Github Repo Route **************************
    /// ==================================================================
    GoRoute(
      name: AppRoutes.GITHUB_REPO_LIST_ROUTE_NAME,
      path: AppRoutes.GITHUB_REPO_LIST_ROUTE_PATH,
      builder: (BuildContext context, GoRouterState state) {
        return const GitHubReposScreen();
      },
    ),

    ///  =================================================================
    /// ********************** Authentication Routes ********************
    /// ==================================================================
    // GoRoute(
    //   name: AppRoutes.LOGIN_ROUTE_NAME,
    //   path: AppRoutes.LOGIN_ROUTE_PATH,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SignInPage();
    //   },
    // ),
    // GoRoute(
    //   name: AppRoutes.SIGNUP_ROUTE_NAME,
    //   path: AppRoutes.SIGNUP_ROUTE_PATH,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const SignUnPage();
    //   },
    // ),

    ///  =================================================================
    /// ********************** DashBoard Route ******************************
    /// ==================================================================
    // GoRoute(
    //   name: AppRoutes.DASHBOARD_ROUTE_NAME,
    //   path: AppRoutes.DASHBOARD_ROUTE_PATH,
    //   builder: (BuildContext context, GoRouterState state) {
    //     return const DashBoardScreen();
    //   },
    // ),
  ],
  errorPageBuilder: (context, state) {
    return const MaterialPage(child: ErrorScreen());
  },
  redirect: (context, state) {
    logger.info('redirect: ${state.uri}');
    return null;
  },
);
