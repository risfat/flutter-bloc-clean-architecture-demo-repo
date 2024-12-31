import 'package:bloc_clean_architecture/src/common/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, void>> login(String email, String password);
}
