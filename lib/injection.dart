import 'package:bloc_clean_architecture/src/features/authentication/data/datasource/authentication_remote_data_source.dart';
import 'package:bloc_clean_architecture/src/features/authentication/data/repository/authentication_repository_impl.dart';
import 'package:bloc_clean_architecture/src/features/authentication/domain/repositories/autentication_repository.dart';
import 'package:bloc_clean_architecture/src/features/authentication/domain/usecase/login.dart';
import 'package:bloc_clean_architecture/src/features/authentication/presentation/bloc/authenticator_watcher/authenticator_watcher_bloc.dart';
import 'package:bloc_clean_architecture/src/features/authentication/presentation/bloc/sign_in_form/sign_in_form_bloc.dart';
import 'package:bloc_clean_architecture/src/features/github/data/datasource/github_remote_data_source.dart';
import 'package:bloc_clean_architecture/src/features/github/data/repositories/github_repository_impl.dart';
import 'package:bloc_clean_architecture/src/features/github/domain/repositories/github_repository.dart';
import 'package:bloc_clean_architecture/src/features/github/domain/usecase/github_repo_search.dart';
import 'package:bloc_clean_architecture/src/features/github/presentation/blocs/github_repos_bloc.dart';
import 'package:bloc_clean_architecture/src/features/theme/presentation/cubit/theme_cubit.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  //TODO: Data sources
  final authRemoteDataSource = AuthenticationRemoteDataSourceImpl();
  locator.registerLazySingleton<AuthenticationRemoteDataSource>(
    () => authRemoteDataSource,
  );

  // Github data sources
  final githubRemoteDataSource = GithubRemoteDataSourceImpl();
  locator.registerLazySingleton<GithubRemoteDataSource>(
    () => githubRemoteDataSource,
  );

  // Repositories
  final authRepository = AuthenticationRepositoryImpl(locator());
  locator.registerLazySingleton<AuthenticationRepository>(
    () => authRepository,
  );

  // Github repository
  final githubRepository = GithubRepositoryImpl(locator());
  locator.registerLazySingleton<GithubRepository>(
    () => githubRepository,
  );

  // Use cases
  final signIn = SignIn(locator());
  locator.registerLazySingleton(
    () => signIn,
  );

  // Github Use case
  final githubRepoSearch = GithubRepositorySearch(locator());
  locator.registerLazySingleton(
    () => githubRepoSearch,
  );

  //TODO:  BLoCs
  final authenticatorWatcherBloc = AuthenticatorWatcherBloc();
  locator.registerLazySingleton(
    () => authenticatorWatcherBloc,
  );

  final signInFormBloc = SignInFormBloc(locator());
  locator.registerLazySingleton(
    () => signInFormBloc,
  );

  final themeCubit = ThemeCubit();
  locator.registerLazySingleton(
    () => themeCubit,
  );

  // Github BLoC
  final githubReposBloc = GitHubReposBloc(locator());
  locator.registerLazySingleton(
    () => githubReposBloc,
  );
}
