import 'package:flutter/material.dart';

import '../../domain/models/github_repo.dart';

class GitHubRepoDetailScreen extends StatelessWidget {
  final GitHubRepo repo;

  const GitHubRepoDetailScreen({Key? key, required this.repo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(repo.name)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(repo.owner.avatarUrl),
                  radius: 30,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(repo.owner.login,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Owner', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 24),
            Text('Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(repo.description ?? 'No description provided'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text('${repo.stargazersCount} stars'),
              ],
            ),
            SizedBox(height: 16),
            Text('Last updated: ${repo.updatedAt.toLocal()}'),
          ],
        ),
      ),
    );
  }
}
