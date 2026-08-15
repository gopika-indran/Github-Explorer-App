import 'package:flutter/foundation.dart';

import '../models/github_repo.dart';
import '../services/api_exceptions.dart';
import '../services/github_api_service.dart';

enum RepoViewState { loading, loaded, error, empty }

enum RepoSortOption { stars, recentlyUpdated }

class RepoListProvider extends ChangeNotifier {
  RepoListProvider({GithubApiService? apiService})
      : _api = apiService ?? GithubApiService();

  final GithubApiService _api;

  RepoViewState _state = RepoViewState.loading;
  List<GithubRepo> _repos = <GithubRepo>[];
  String? _errorMessage;
  RepoSortOption _sortOption = RepoSortOption.recentlyUpdated;

  RepoViewState get state => _state;
  String? get errorMessage => _errorMessage;
  RepoSortOption get sortOption => _sortOption;

  List<GithubRepo> get repos {
    final sorted = List<GithubRepo>.from(_repos);
    switch (_sortOption) {
      case RepoSortOption.stars:
        sorted.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
      case RepoSortOption.recentlyUpdated:
        sorted.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
    }
    return sorted;
  }

  Future<void> fetchRepos(String username) async {
    _state = RepoViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _api.fetchRepos(username);
      _repos = result;
      _state = result.isEmpty ? RepoViewState.empty : RepoViewState.loaded;
    } on UserNotFoundException {
      _state = RepoViewState.error;
      _errorMessage = 'This user could not be found.';
    } on NetworkException catch (e) {
      _state = RepoViewState.error;
      _errorMessage = e.toString();
    } on ApiException catch (e) {
      _state = RepoViewState.error;
      _errorMessage = e.toString();
    } catch (e) {
      _state = RepoViewState.error;
      _errorMessage = 'Unexpected error occurred. Please try again.';
    }
    notifyListeners();
  }

  void setSortOption(RepoSortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    notifyListeners();
  }

  @override
  void dispose() {
    _api.dispose();
    super.dispose();
  }
}
