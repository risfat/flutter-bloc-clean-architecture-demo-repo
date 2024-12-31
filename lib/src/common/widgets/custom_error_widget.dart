import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  String get userFriendlyMessage {
    if (errorMessage.contains('ApiException: Not found')) {
      return 'The requested information could not be found. Please try again later.';
    } else if (errorMessage.contains('ApiException')) {
      return 'There was a problem connecting to the server. Please check your internet connection and try again.';
    } else if (errorMessage.contains('API rate limit likely exceeded')) {
      return 'Please try again later, as the API rate limit has likely been exceeded.';
    } else {
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 80,
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .then(delay: 200.ms)
                .shake(duration: 700.ms),
            const SizedBox(height: 24),
            Text(
              errorMessage.contains('API rate limit likely exceeded')
                  ? 'Api Rate Limit Exceeded !'
                  : 'Oops! Something went wrong',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad),
            const SizedBox(height: 16),
            Text(
              userFriendlyMessage,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                curve: Curves.easeOutQuad),
            const SizedBox(height: 32),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff3C8DBC),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text('Retry',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white)),
              )
                  .animate()
                  .scale(
                      duration: 600.ms,
                      delay: 900.ms,
                      curve: Curves.easeOutBack)
                  .then(delay: 200.ms)
                  .shimmer(
                      duration: 1200.ms, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
