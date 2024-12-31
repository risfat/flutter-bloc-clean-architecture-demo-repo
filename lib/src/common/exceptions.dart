class ServerException implements Exception {
  ServerException(this.message);
  final String message;
}

class DatabaseException implements Exception {
  DatabaseException(this.message);
  final String message;
}

class CacheException implements Exception {
  CacheException(this.message);
  final String message;
}

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'User does not exist']);

  @override
  String toString() => message;
}

class AccountNotCreatedException implements Exception {
  final String message;
  AccountNotCreatedException(
      [this.message = 'Account not created. Please try again later.']);
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
}

class UnexpectedException implements Exception {
  final String message;
  UnexpectedException(this.message);
}
