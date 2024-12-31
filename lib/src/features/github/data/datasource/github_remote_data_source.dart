import 'package:dio/dio.dart';

import '../../../../common/api.dart';
import '../../../../common/dio_client.dart';
import '../../domain/models/github_repo.dart';

abstract class GithubRemoteDataSource {
  Future<List<GitHubRepo>> searchRepositories(
      String query, int page, int perPage);
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  static final Dio _dio = DioClient.instance;
  // final TokenService _tokenService = TokenService(_dio);

  @override
  Future<List<GitHubRepo>> searchRepositories(
      String query, int page, int perPage) async {
    try {
      final response = await _dio.get(
        API.SEARCH_REPOSITORIES,
        queryParameters: {
          'q': '$query language:dart',
          'sort': 'stars',
          'order': 'desc',
          'page': page,
          'per_page': perPage,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> items = response.data['items'];
        return items.map((item) => GitHubRepo.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load repositories');
      }
    } catch (e) {
      throw Exception('Error searching repositories: $e');
    }
  }
}
