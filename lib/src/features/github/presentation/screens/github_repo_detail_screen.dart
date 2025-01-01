import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/constants.dart';
import '../../domain/models/github_repo.dart';

class GitHubRepoDetailScreen extends StatelessWidget {
  final GitHubRepo repo;

  const GitHubRepoDetailScreen({Key? key, required this.repo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                repo.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'repo-${repo.id}',
                    child: Image.network(
                      repo.owner.avatarUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(MARGIN),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOwnerInfo(),
                  const SizedBox(height: SPACE25),
                  _buildDescription(),
                  const SizedBox(height: SPACE25),
                  _buildStats(),
                  const SizedBox(height: SPACE25),
                  _buildDates(),
                  const SizedBox(height: SPACE25),
                  _buildOpenRepoButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(repo.owner.avatarUrl),
          radius: 30,
        ),
        const SizedBox(width: SPACE15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                repo.owner.login,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: SPACE4),
              Text(
                'Owner • ${repo.owner.type}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: SPACE8),
        Text(repo.description ?? 'No description provided'),
      ],
    );
  }

  Widget _buildStats() {
    return Wrap(
      spacing: SPACE15,
      runSpacing: SPACE15,
      children: [
        _buildStatItem(Icons.star, repo.stargazersCount.toString(), 'Stars'),
        _buildStatItem(
            Icons.remove_red_eye, repo.watchersCount.toString(), 'Watchers'),
        _buildStatItem(Icons.call_split, repo.forksCount.toString(), 'Forks'),
        _buildStatItem(
            Icons.error_outline, repo.openIssuesCount.toString(), 'Issues'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String count, String label) {
    return Container(
      padding: const EdgeInsets.all(SPACE8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(RADIUS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: SPACE4),
          Text('$count $label'),
        ],
      ),
    );
  }

  Widget _buildDates() {
    final dateFormat = DateFormat('MMM d, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDateItem('Created', dateFormat.format(repo.createdAt)),
        const SizedBox(height: SPACE8),
        _buildDateItem('Last updated', dateFormat.format(repo.updatedAt)),
        if (repo.pushedAt != null) ...[
          const SizedBox(height: SPACE8),
          _buildDateItem('Last pushed', dateFormat.format(repo.pushedAt!)),
        ],
      ],
    );
  }

  Widget _buildDateItem(String label, String date) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(date),
      ],
    );
  }

  Widget _buildOpenRepoButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        icon: const Icon(Icons.open_in_new),
        label: const Text('Open Repository'),
        onPressed: () => _launchUrl(repo.htmlUrl, context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              horizontal: SPACE25, vertical: SPACE12),
        ),
      ),
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    final Uri parsedUrl = Uri.parse(url);
    if (!await launchUrl(parsedUrl)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the repository')),
      );
    }
  }
}
