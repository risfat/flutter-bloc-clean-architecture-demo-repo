import 'package:bloc_clean_architecture/src/common/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../authentication/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Future.microtask(
        () => context.read<AuthenticatorWatcherBloc>().add(
              const AuthenticatorWatcherEvent.authCheckRequest(),
            ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
      listener: (context, state) {
        state.maybeMap(
            orElse: () {},
            authenticating: (_) {},
            authenticated: (_) {
              context.replaceNamed(AppRoutes.GITHUB_REPO_LIST_ROUTE_NAME);
            },
            isFirstTime: (_) {
              context.replaceNamed(AppRoutes.GITHUB_REPO_LIST_ROUTE_NAME);
            },
            unauthenticated: (_) {
              context.replaceNamed(AppRoutes.GITHUB_REPO_LIST_ROUTE_NAME);
            });
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _animation,
                child: const Icon(
                  Icons.code,
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _animation,
                child: const Text(
                  'GitHub Repos',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: _animation.drive(
                  ColorTween(begin: Colors.blue.shade200, end: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
