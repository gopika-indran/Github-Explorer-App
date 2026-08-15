
class GithubRepo {
  final int id;
  final String name;
  final String? description;
  final int stargazersCount;
  final int forksCount;
  final int watchersCount;
  final String? language;
  final DateTime updatedAt;
  final String htmlUrl;
  final bool fork;
  final bool isPrivate;

  const GithubRepo({
    required this.id,
    required this.name,
    this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.watchersCount,
    this.language,
    required this.updatedAt,
    required this.htmlUrl,
    required this.fork,
    required this.isPrivate,
  });

  factory GithubRepo.fromJson(Map<String, dynamic> json) {
    return GithubRepo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'unnamed-repo',
      description: json['description'] as String?,
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      forksCount: json['forks_count'] as int? ?? 0,
      watchersCount: json['watchers_count'] as int? ?? 0,
      language: json['language'] as String?,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      htmlUrl: json['html_url'] as String? ?? '',
      fork: json['fork'] as bool? ?? false,
      isPrivate: json['private'] as bool? ?? false,
    );
  }
}
