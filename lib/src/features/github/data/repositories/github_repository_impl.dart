import 'dart:io';

import 'package:bloc_clean_architecture/src/common/exceptions.dart';
import 'package:bloc_clean_architecture/src/common/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/models/github_repo.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasource/github_remote_data_source.dart';

class GithubRepositoryImpl extends GithubRepository {
  GithubRepositoryImpl(this.dataSource);
  final GithubRemoteDataSource dataSource;

  @override
  Future<Either<Failure, List<GitHubRepo>>> searchRepositories(
      String query, int page, int perPage) async {
    try {
      final result = await dataSource.searchRepositories(query, page, perPage);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on SocketException {
      return const Left(
        ConnectionFailure('No internet connection'),
      );
    } on DioException catch (e) {
      return _handleDioException(e);
    } catch (e) {
      return _handleGeneralException(e);
    }
  }

  Either<Failure, List<GitHubRepo>> _handleDioException(DioException e) {
    if (e.response?.statusCode == 403 &&
        e.response?.data['message']
                ?.toString()
                .toLowerCase()
                .contains('rate limit exceeded') ==
            true) {
      return Left(RateLimitExceededFailure(
          e.response?.data['message'] ?? 'API rate limit exceeded'));
    }
    return Left(
      ServerFailure(
        e.response?.data['message'] ?? 'Error occurred. Please try again',
      ),
    );
  }

  Either<Failure, List<GitHubRepo>> _handleGeneralException(dynamic e) {
    print("===========================Error: $e =============================");
    if (e.toString().toLowerCase().contains('dioexception')) {
      // This is likely our wrapped DioException
      if (e.toString().toLowerCase().contains('rate limit exceeded')) {
        return const Left(RateLimitExceededFailure('API rate limit exceeded'));
      }
      if (e.toString().contains('status code of 403')) {
        return const Left(
            RateLimitExceededFailure('API rate limit likely exceeded'));
      }
      return const Left(
          ServerFailure('Error occurred while connecting to the server'));
    }
    if (e.toString().toLowerCase().contains('rate limit exceeded')) {
      return const Left(RateLimitExceededFailure('API rate limit exceeded'));
    }
    return Left(ServerFailure('Unexpected error occurred: ${e.toString()}'));
  }
}
