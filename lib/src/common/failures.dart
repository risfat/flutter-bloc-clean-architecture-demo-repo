import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);
  final String message;

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NoDataFailure extends Failure {
  const NoDataFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message);
}

class ValidationFailure extends Failure {
  final List<String> errors;

  ValidationFailure(this.errors) : super(errors.join(', '));
}

class RateLimitExceededFailure extends Failure {
  const RateLimitExceededFailure(super.message);
}
