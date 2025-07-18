import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthScreen extends StatefulWidget {
  // Login tab or Register tab
  final String initialTab;
  const AuthScreen({
    super.key,
    required this.initialTab,  
  });

  @override
  State<AuthScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  late TabController _tabController;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Set initial tab based on widget parameter
    if (widget.initialTab == 'register') {
      _tabController.index = 1; // Switch to Register tab
    } else {
      _tabController.index = 0; // Default to Login tab
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.login(AuthProvider.google);
      
      if (!mounted) return;
      
      if (authViewModel.status == AuthStatus.authenticated) {
        context.push('/');
      } else {
        if (authViewModel.errorMessage.isNotEmpty) {
          _showErrorSnackBar(authViewModel.errorMessage);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(24),
          child: Card(
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo and title
                  Text(
                    'GameVerse',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome to the ultimate gaming platform',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab bar for Login/Register
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Login'),
                      Tab(text: 'Register'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Tab content
                  SizedBox(
                    height: 410,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        LoginForm(showErrorSnackBar: _showErrorSnackBar),
                        SignupForm(showErrorSnackBar: _showErrorSnackBar),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Google Sign In
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleLogin,
                      icon: const Icon(Icons.g_mobiledata, size: 24),
                      label: const Text('Continue with Google'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Back to home
                  TextButton(
                    onPressed: () => context.push('/'),
                    child: const Text('Continue as Guest'),
                  ),
                  
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}