import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/failures.dart';
import '../../domain/models/github_repo.dart';
import '../../domain/usecase/github_repo_search.dart';

// Events
abstract class GitHubReposEvent {}

class FetchGitHubRepos extends GitHubReposEvent {}

class LoadMoreGitHubRepos extends GitHubReposEvent {}

// States
abstract class GitHubReposState {}

class GitHubReposInitial extends GitHubReposState {}

class GitHubReposLoading extends GitHubReposState {}

class GitHubReposLoaded extends GitHubReposState {
  final List<GitHubRepo> repos;
  final bool hasReachedMax;

  GitHubReposLoaded(this.repos, this.hasReachedMax);
}

class GitHubReposError extends GitHubReposState {
  final String message;

  GitHubReposError(this.message);
}

class GitHubReposRateLimitExceeded extends GitHubReposState {
  final String message;

  GitHubReposRateLimitExceeded(this.message);
}

// BLoC
class GitHubReposBloc extends Bloc<GitHubReposEvent, GitHubReposState> {
  final GithubRepositorySearch repository;
  int _currentPage = 1;
  final int _perPage = 20;

  GitHubReposBloc(this.repository) : super(GitHubReposInitial()) {
    on<FetchGitHubRepos>(_onFetchGitHubRepos);
    on<LoadMoreGitHubRepos>(_onLoadMoreGitHubRepos);
  }

  Future<void> _onFetchGitHubRepos(
      FetchGitHubRepos event, Emitter<GitHubReposState> emit) async {
    emit(GitHubReposLoading());
    final result = await repository.execute('Flutter', _currentPage, _perPage);
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (repos) => emit(GitHubReposLoaded(repos, repos.length < _perPage)),
    );
  }

  Future<void> _onLoadMoreGitHubRepos(
      LoadMoreGitHubRepos event, Emitter<GitHubReposState> emit) async {
    if (state is GitHubReposLoaded) {
      final currentState = state as GitHubReposLoaded;
      if (!currentState.hasReachedMax) {
        _currentPage++;
        final result =
            await repository.execute('Flutter', _currentPage, _perPage);
        result.fold(
          (failure) => emit(_mapFailureToState(failure)),
          (newRepos) => emit(GitHubReposLoaded(
            [...currentState.repos, ...newRepos],
            newRepos.length < _perPage,
          )),
        );
      }
    }
  }

  GitHubReposState _mapFailureToState(Failure failure) {
    print("====== Failure ==== ");
    print(failure);
    print("=================================");
    if (failure is RateLimitExceededFailure) {
      return GitHubReposRateLimitExceeded(failure.message);
    }
    return GitHubReposError(_mapFailureToMessage(failure));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server failure: ${(failure as ServerFailure).message}';
      case ConnectionFailure:
        return 'Connection failure';
      case RateLimitExceededFailure:
        return (failure as RateLimitExceededFailure).message;
      default:
        return 'Unexpected error';
    }
  }
}
