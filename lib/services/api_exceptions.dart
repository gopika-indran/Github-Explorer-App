/// Thrown when a requested GitHub user does not exist (HTTP 404).
class UserNotFoundException implements Exception {
  final String username;
  const UserNotFoundException(this.username);

  @override
  String toString() => 'User not found';
}

class NetworkException implements Exception {
  final String message;
  const NetworkException([this.message = 'Network error. Check your connection and try again.']);

  @override
  String toString() => message;
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => message;
}
