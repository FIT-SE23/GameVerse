import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:gameverse/data/repositories/auth_repository.dart';

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
        
        // For demo purposes, we'll use the default login
        await authViewModel.login(AuthProvider.supabase);
        
        if (!mounted) return;
        
        if (authViewModel.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed('/');
        } else {
          _showErrorSnackBar(authViewModel.errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
      // Implement login logic here
      // After login, set _isLoading to false
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          // Email field
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
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
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: const Text('Login'),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Forgot password
          TextButton(
            onPressed: () {
              // Implement forgot password
            },
            child: const Text('Forgot Password?'),
          ),
        ],
      ),
    );
  }
}