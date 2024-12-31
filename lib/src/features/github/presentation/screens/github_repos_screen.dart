import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../common/widgets/custom_error_widget.dart';
import '../blocs/github_repos_bloc.dart';
import '../widgets/github_repo_card.dart';
import 'github_repo_detail_screen.dart';

class GitHubReposScreen extends StatelessWidget {
  const GitHubReposScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter GitHub Repos'),
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocBuilder<GitHubReposBloc, GitHubReposState>(
        builder: (context, state) {
          if (state is GitHubReposInitial) {
            BlocProvider.of<GitHubReposBloc>(context).add(FetchGitHubRepos());
            return _buildLoadingIndicator();
          } else if (state is GitHubReposLoading) {
            return _buildLoadingIndicator();
          } else if (state is GitHubReposLoaded) {
            return _buildRepoList(context, state);
          } else if (state is GitHubReposRateLimitExceeded) {
            return _buildErrorWidget(context, state.message);
          } else if (state is GitHubReposError) {
            return _buildErrorWidget(context, state.message);
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading repositories...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRepoList(BuildContext context, GitHubReposLoaded state) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          BlocProvider.of<GitHubReposBloc>(context).add(LoadMoreGitHubRepos());
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<GitHubReposBloc>(context).add(FetchGitHubRepos());
        },
        child: AnimationLimiter(
          child: ListView.builder(
            itemCount: state.repos.length + (state.hasReachedMax ? 0 : 1),
            itemBuilder: (context, index) {
              if (index >= state.repos.length) {
                return _buildLoadingIndicator();
              }
              final repo = state.repos[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GitHubRepoDetailScreen(repo: repo),
                          ),
                        );
                      },
                      child: GitHubRepoCard(repo: repo),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return CustomErrorWidget(
      errorMessage: message,
      onRetry: () {
        BlocProvider.of<GitHubReposBloc>(context).add(FetchGitHubRepos());
      },
    );
  }
}
