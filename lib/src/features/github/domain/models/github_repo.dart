class GitHubRepo {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String defaultBranch;
  final String visibility;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? pushedAt;
  final String htmlUrl;
  final GitHubOwner owner;

  GitHubRepo({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    required this.defaultBranch,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
    this.pushedAt,
    required this.htmlUrl,
    required this.owner,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) {
    return GitHubRepo(
      id: json['id'],
      name: json['name'],
      fullName: json['full_name'],
      description: json['description'],
      language: json['language'],
      stargazersCount: json['stargazers_count'],
      watchersCount: json['watchers_count'],
      forksCount: json['forks_count'],
      openIssuesCount: json['open_issues_count'],
      defaultBranch: json['default_branch'],
      visibility: json['visibility'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pushedAt:
          json['pushed_at'] != null ? DateTime.parse(json['pushed_at']) : null,
      htmlUrl: json['html_url'],
      owner: GitHubOwner.fromJson(json['owner']),
    );
  }
}

class GitHubOwner {
  final int id;
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final String type;

  GitHubOwner({
    required this.id,
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.type,
  });

  factory GitHubOwner.fromJson(Map<String, dynamic> json) {
    return GitHubOwner(
      id: json['id'],
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
      type: json['type'],
    );
  }
}
