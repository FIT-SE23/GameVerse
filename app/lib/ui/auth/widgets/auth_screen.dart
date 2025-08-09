import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'login_form.dart';
import 'signup_form.dart';

import 'package:gameverse/ui/shared/widgets/page_footer.dart';

// import 'package:flutter_svg/flutter_svg.dart';

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
    if (widget.initialTab == 'signup') {
      _tabController.index = 1; // Switch to Sign up tab
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
  
  Future<void> _handleLogin(AuthProvider provider) async {
    setState(() => _isLoading = true);
    
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.login(provider);
      
      if (!mounted) return;
      
      if (authViewModel.status == AuthStatus.authenticated) {
        context.pop();
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
    
    final tabList = const [
      Tab(text: 'Log in'),
      Tab(text: 'Sign up'),
    ];

    final formList = [
      LoginForm(showErrorSnackBar: _showErrorSnackBar),
      SignupForm(showErrorSnackBar: _showErrorSnackBar),
    ];

    // String logoAddr;
    // if (Theme.brightnessOf(context) == Brightness.dark) {
    //   logoAddr = 'assets/logo/logo_horizontal_white.svg';
    // } else {
    //   logoAddr = 'assets/logo/logo_horizontal_black.svg';
    // }

    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.all(24),
              child: Card(
                shape: RoundedRectangleBorder(),
                shadowColor: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo and title
                      const SizedBox(height: 32),
                      // Center(
                      //   child: Transform.scale(
                      //     scale: 1,
                      //     origin: Offset(0, 0),
                      //     child: SvgPicture.asset(logoAddr, fit: BoxFit.fitHeight, width: 10, height: 80,)
                      //   ),
                      // ),
                      // const SizedBox(height: 40),
                      // Text(
                      //   'Welcome to the ultimate gaming platform',
                      //   style: theme.textTheme.bodyMedium,
                      //   textAlign: TextAlign.center,
                      // ),
                      // const SizedBox(height: 16),
                      
                      // Tab bar for Login/Register
                      TabBar(
                        controller: _tabController,
                        onTap: (int index) {
                          setState(() {});
                        },
                        tabs: tabList,
                      ),
                      const SizedBox(height: 16),
                      
                      // Tab content
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          // print('index: ${_tabController.index}');
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey(_tabController.index),
                          constraints: BoxConstraints(minHeight: 360),
                          child: formList[_tabController.index],
                        ),
                      ),
                      // SizedBox(
                      //   height: 410,
                      //   child: TabBarView(
                      //     controller: _tabController,
                      //     children: [
                      //       LoginForm(showErrorSnackBar: _showErrorSnackBar),
                      //       SignupForm(showErrorSnackBar: _showErrorSnackBar),
                      //     ],
                      //   ),
                      // ),
                      
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
                          onPressed: _isLoading ? null : () => _handleLogin(AuthProvider.google),
                          icon: const Icon(Icons.g_mobiledata, size: 24),
                          label: const Text('Continue with Google'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
          
                      // Facebook Sign In
                      // SizedBox(
                      //   width: double.infinity,
                      //   child: OutlinedButton.icon(
                      //     onPressed: _isLoading ? null : () => _handleLogin(AuthProvider.facebook),
                      //     icon: const Icon(Icons.facebook_rounded, size: 24),
                      //     label: const Text('Continue with Facebook'),
                      //     style: OutlinedButton.styleFrom(
                      //       padding: const EdgeInsets.symmetric(vertical: 12),
                      //     ),
                      //   ),
                      // ),
                      
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

          PageFooter()
        ],
      ),
    );
  }
}