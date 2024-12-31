import 'package:dartz/dartz.dart';

import '../../../../common/failures.dart';
import '../models/github_repo.dart';

abstract class GithubRepository {
  Future<Either<Failure, List<GitHubRepo>>> searchRepositories(
      String query, int page, int perPage);
}
