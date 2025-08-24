import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gameverse/routing/routes.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';

import 'package:gameverse/config/app_theme.dart';

class SignupForm extends StatefulWidget {
  final Function(String) _showErrorSnackBar;
  const SignupForm({super.key, required Function(String) showErrorSnackBar})
      : _showErrorSnackBar = showErrorSnackBar;

  @override
  State<SignupForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignupForm> {
  void _showErrorSnackBar(String message) {
    widget._showErrorSnackBar(message);
  }
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        if (!_termsAccepted) {
          _showErrorSnackBar('You must accept the terms to register.');
          return;
        }

        final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
        bool isRegistered = await authViewModel.register(
          _nameController.text.trim(),
          _emailController.text.trim(),
          _passwordController.text,
        );
        
        if (!mounted) return;
        
        if (isRegistered) {
          context.pushReplacement('/login');
        } else {
          // Show error message
          _showErrorSnackBar(authViewModel.errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
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
          // Name field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'User Name',
              prefixIcon: Icon(Icons.person),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Email field
          TextFormField(
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
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Confirm Password field
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
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
            obscureText: !_isConfirmPasswordVisible,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Condition term checkbox with link, at least 3 lines
          Row(
            children: [
              Checkbox(
                value: _termsAccepted,
                onChanged: (value) {
                  setState(() {
                    _termsAccepted = value!;
                  });
                },
              ),
              Expanded(
                child: RichText(text: TextSpan(
                  text: 'I agree to the ',
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push(Routes.termsOfService);
                        },
                    ),
                    const TextSpan(text: ' and the '),
                    TextSpan(
                      text: 'GameVerse Store End User License Agreement',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.push(Routes.eula);
                        },
                    ),
                  ],
                )),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Register button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}