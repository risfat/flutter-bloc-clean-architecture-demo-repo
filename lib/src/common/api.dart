// ignore_for_file: constant_identifier_names

class API {
  static const BASE_URL = 'https://api.github.com';

  // Authentication
  static const LOGIN = '$BASE_URL/auth/login';
  static const REGISTER = '$BASE_URL/auth/register';
  static const String REFRESH_TOKEN = '$BASE_URL/auth/refresh';

  // GitHub Search API
  static const SEARCH_REPOSITORIES = '$BASE_URL/search/repositories';
}
