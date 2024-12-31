import 'dart:async';

import 'package:bloc_clean_architecture/src/common/themes.dart';
import 'package:bloc_clean_architecture/src/features/authentication/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/features/github/presentation/blocs/github_repos_bloc.dart';
import 'package:bloc_clean_architecture/src/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:bloc_clean_architecture/src/utilities/app_bloc_observer.dart';
import 'package:bloc_clean_architecture/src/utilities/logger.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import './injection.dart' as di;
import 'src/utilities/go_router_init.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () {
        WidgetsFlutterBinding.ensureInitialized();
        Bloc.transformer = bloc_concurrency.sequential();
        Bloc.observer = const AppBlocObserver();
        di.init();

        runApp(const MyApp());
      },
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<AuthenticatorWatcherBloc>()),
        BlocProvider(create: (_) => di.locator<ThemeCubit>()),
        BlocProvider(create: (_) => di.locator<GitHubReposBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Github Repos',
        theme: themeLight(context),
        darkTheme: themeDark(context),
        themeMode: ThemeMode.system,
        routerConfig: routerInit,
      ),
    );
  }
}
