import 'package:flutter/material.dart';
import 'package:gameverse/routing/routes.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';
import 'package:gameverse/ui/transaction/view_model/transaction_viewmodel.dart';

import 'package:gameverse/config/app_theme.dart';

class LoginForm extends StatefulWidget {
  final Function(String) _showErrorSnackBar;
  const LoginForm({super.key, required Function(String) showErrorSnackBar})
      : _showErrorSnackBar = showErrorSnackBar;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  void _showErrorSnackBar(String message) {
    widget._showErrorSnackBar(message);
  }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        
        await authViewModel.login(AuthProvider.server,
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        if (!mounted) return;
        
        if (authViewModel.status == AuthStatus.authenticated) {
          context.pop();
        } else {
          _showErrorSnackBar(authViewModel.errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
          Provider.of<TransactionViewModel>(context, listen: false)
            .init(); // Initialize transaction view model after login
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double radius = 6;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Email field
          TextFormField(
            key: ValueKey('email_field'),
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getText),
                borderRadius: BorderRadius.circular(radius)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getCyan),
                borderRadius: BorderRadius.circular(radius)
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(radius)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(radius)
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Password field
          TextFormField(
            key: ValueKey('password_field'),
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getText),
                borderRadius: BorderRadius.circular(radius)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppTheme.currentThemeColors(theme.brightness).getCyan),
                borderRadius: BorderRadius.circular(radius)
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(radius)
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade300),
                borderRadius: BorderRadius.circular(radius)
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                context.push(Routes.forgotPassword);
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 30),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: ValueKey('confirm_login_button'),
              onPressed: _isLoading ? null : _handleLogin,
              child: const Text('Log in'),
            ),
          ),
          
          const SizedBox(height: 16),
          
        ],
      ),
    );
  }
}