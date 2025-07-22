import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

class AuthCallbackScreen extends StatefulWidget {
  const AuthCallbackScreen({super.key});

  @override
  State<AuthCallbackScreen> createState() => _AuthCallbackScreenState();
}

class _AuthCallbackScreenState extends State<AuthCallbackScreen> {
  @override
  void initState() {
    super.initState();
    _handleWebAuthCallback();
  }

  Future<void> _handleWebAuthCallback() async {
    if (!kIsWeb) {
      // Redirect to desktop callback handler
      context.go('/');
      return;
    }

    try {
      // Parse URL hash for authentication tokens (for web OAuth)
      final uri = Uri.parse(Uri.base.toString());
      debugPrint('Web auth callback URI: $uri');
      debugPrint('Fragment: ${uri.fragment}');
      debugPrint('Query parameters: ${uri.queryParameters}');

      // Time to process the callback
      await Future.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        
        // Force refresh the auth state
        await authViewModel.init();
        
        // Wait a bit more if needed
        if (authViewModel.status != AuthStatus.authenticated) {
          await Future.delayed(const Duration(seconds: 1));
          await authViewModel.init();
        }

        if (mounted) {
          if (authViewModel.status == AuthStatus.authenticated) {
            debugPrint('Web authentication successful, redirecting to home');
            context.go('/');
            
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Successfully logged in!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            debugPrint('Web authentication failed');
            context.go('/login');
            
            // Show error message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${authViewModel.errorMessage}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Web auth callback error: $e');
      if (mounted) {
        context.go('/login');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Completing authentication...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait while we sign you in',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}