import 'package:bloc_clean_architecture/src/common/failures.dart';
import 'package:bloc_clean_architecture/src/features/github/domain/repositories/github_repository.dart';
import 'package:dartz/dartz.dart';

import '../models/github_repo.dart';

class GithubRepositorySearch {
  GithubRepositorySearch(this._repository);
  final GithubRepository _repository;

  Future<Either<Failure, List<GitHubRepo>>> execute(
      String query, int page, int perPage) async {
    return await _repository.searchRepositories(query, page, perPage);
  }
}
