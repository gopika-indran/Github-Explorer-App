import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/github_repo.dart';
import '../models/github_user.dart';
import 'api_exceptions.dart';

class GithubApiService {
  GithubApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://api.github.com';
  final http.Client _client;
  final Duration _timeout = const Duration(seconds: 15);

  Map<String, String> get _headers => {
        'Accept': 'application/vnd.github+json',
        'X-GitHub-Api-Version': '2022-11-28',
      };

  Future<GithubUser> fetchUser(String username) async {
    final uri = Uri.parse('$_baseUrl/users/${Uri.encodeComponent(username)}');
    final response = await _safeGet(uri);
    _throwIfError(response, username);
    return GithubUser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<GithubRepo>> fetchRepos(String username) async {
    final uri = Uri.parse(
      '$_baseUrl/users/${Uri.encodeComponent(username)}/repos?per_page=100&sort=updated',
    );
    final response = await _safeGet(uri);
    _throwIfError(response, username);
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => GithubRepo.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
  }

  Future<http.Response> _safeGet(Uri uri) async {
    try {
      return await _client.get(uri, headers: _headers).timeout(_timeout);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out. Please try again.');
    } on http.ClientException {
      throw const NetworkException();
    }
  }

  void _throwIfError(http.Response response, String username) {
    switch (response.statusCode) {
      case 200:
        return;
      case 404:
        throw UserNotFoundException(username);
      case 403:
      case 429:
        throw const ApiException(
          'GitHub API rate limit exceeded. Please wait a bit and try again.',
        );
      default:
        throw ApiException('Something went wrong (HTTP ${response.statusCode}).');
    }
  }

  void dispose() => _client.close();
}
