import 'package:bloc_clean_architecture/src/common/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/autentication_repository.dart';

class SignIn {
  SignIn(this._repository);
  final AuthenticationRepository _repository;

  Future<Either<Failure, void>> execute(String email, String password) async {
    return await _repository.login(email, password);
  }
}
