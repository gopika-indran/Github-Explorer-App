import 'package:flutter/foundation.dart';

import '../models/github_user.dart';
import '../services/api_exceptions.dart';
import '../services/github_api_service.dart';
import '../services/recent_search_storage.dart';


enum SearchViewState { idle, loading, loaded, error }

enum SearchErrorType { notFound, network, api }

class UserSearchProvider extends ChangeNotifier {
  UserSearchProvider({
    GithubApiService? apiService,
    RecentSearchStorage? storage,
  })  : _api = apiService ?? GithubApiService(),
        _storage = storage ?? RecentSearchStorage() {
    _loadRecentSearches();
  }

  final GithubApiService _api;
  final RecentSearchStorage _storage;

  SearchViewState _state = SearchViewState.idle;
  GithubUser? _user;
  String? _errorMessage;
  SearchErrorType? _errorType;
  List<String> _recentSearches = <String>[];
  String _lastQuery = '';

  SearchViewState get state => _state;
  GithubUser? get user => _user;
  String? get errorMessage => _errorMessage;
  SearchErrorType? get errorType => _errorType;
  List<String> get recentSearches => List.unmodifiable(_recentSearches);
  String get lastQuery => _lastQuery;

  Future<void> _loadRecentSearches() async {
    _recentSearches = await _storage.load();
    notifyListeners();
  }

  Future<void> searchUser(String rawUsername) async {
    final username = rawUsername.trim();
    if (username.isEmpty) return;

    _lastQuery = username;
    _state = SearchViewState.loading;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();

    try {
      final result = await _api.fetchUser(username);
      _user = result;
      _state = SearchViewState.loaded;
      _recentSearches = await _storage.add(result.login);
    } on UserNotFoundException {
      _state = SearchViewState.error;
      _errorType = SearchErrorType.notFound;
      _errorMessage = "We couldn't find a user with that username. Please try again.";
    } on NetworkException catch (e) {
      _state = SearchViewState.error;
      _errorType = SearchErrorType.network;
      _errorMessage = e.toString();
    } on ApiException catch (e) {
      _state = SearchViewState.error;
      _errorType = SearchErrorType.api;
      _errorMessage = e.toString();
    } catch (e) {
      _state = SearchViewState.error;
      _errorType = SearchErrorType.api;
      _errorMessage = 'Unexpected error occurred. Please try again.';
    }
    notifyListeners();
  }

  Future<void> clearRecentSearches() async {
    await _storage.clear();
    _recentSearches = <String>[];
    notifyListeners();
  }

  void reset() {
    _state = SearchViewState.idle;
    _user = null;
    _errorMessage = null;
    _errorType = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
