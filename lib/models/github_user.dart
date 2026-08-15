
class GithubUser {
  final int id;
  final String login;
  final String avatarUrl;
  final String? name;
  final String? bio;
  final String? company;
  final String? location;
  final String? blog;
  final String? email;
  final int followers;
  final int following;
  final int publicRepos;
  final int publicGists;
  final String htmlUrl;
  final DateTime? createdAt;

  const GithubUser({
    required this.id,
    required this.login,
    required this.avatarUrl,
    this.name,
    this.bio,
    this.company,
    this.location,
    this.blog,
    this.email,
    required this.followers,
    required this.following,
    required this.publicRepos,
    required this.publicGists,
    required this.htmlUrl,
    this.createdAt,
  });

  String get displayName => (name != null && name!.trim().isNotEmpty) ? name! : login;

  factory GithubUser.fromJson(Map<String, dynamic> json) {
    return GithubUser(
      id: json['id'] as int? ?? 0,
      login: json['login'] as String? ?? 'unknown',
      avatarUrl: json['avatar_url'] as String? ?? '',
      name: json['name'] as String?,
      bio: json['bio'] as String?,
      company: json['company'] as String?,
      location: json['location'] as String?,
      blog: (json['blog'] as String?)?.trim().isEmpty ?? true ? null : json['blog'] as String?,
      email: json['email'] as String?,
      followers: json['followers'] as int? ?? 0,
      following: json['following'] as int? ?? 0,
      publicRepos: json['public_repos'] as int? ?? 0,
      publicGists: json['public_gists'] as int? ?? 0,
      htmlUrl: json['html_url'] as String? ?? 'https://github.com/${json['login'] ?? ''}',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'login': login,
      'avatar_url': avatarUrl,
      'name': name,
      'bio': bio,
      'company': company,
      'location': location,
      'blog': blog,
      'email': email,
      'followers': followers,
      'following': following,
      'public_repos': publicRepos,
      'public_gists': publicGists,
      'html_url': htmlUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
