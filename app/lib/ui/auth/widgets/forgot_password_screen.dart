import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gameverse/ui/auth/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  String _state = 'requestEmail'; // or 'enterOtp' or 'resetPassword'
  
  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                padding: const EdgeInsets.all(24),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadowColor: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with back button
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => {
                                // Return to previous state
                                if (_state == 'enterOtp') {
                                  setState(() {
                                    _state = 'requestEmail';
                                    _errorMessage = '';
                                  })
                                } else if (_state == 'resetPassword') {
                                  setState(() {
                                    _state = 'enterOtp';
                                    _errorMessage = '';
                                  })
                                } else {
                                  context.go('/login')
                                }
                              },
                            ),
                            const SizedBox(width: 16),
                            Text(
                              _getHeaderText(),
                              style: theme.textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Progress indicator
                        _buildProgressIndicator(),
                        const SizedBox(height: 32),
                        
                        // Content based on state
                        if (_state == 'requestEmail')
                          _buildEmailRequestForm()
                        else if (_state == 'enterOtp') 
                          _buildOtpForm()
                        else if (_state == 'resetPassword')
                          _buildPasswordResetForm(),
                          
                        // Error message
                        if (_errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              _errorMessage,
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                          
                        const SizedBox(height: 32),
                        
                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: _isLoading 
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(_getButtonText()),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Cancel button
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () => context.go('/login'),
                            child: const Text('Back to Login'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const PageFooter(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Row(
      children: [
        _buildProgressStep(1, 'Email', _state == 'requestEmail'),
        _buildProgressLine(1),
        _buildProgressStep(2, 'Verify', _state == 'enterOtp'),
        _buildProgressLine(2),
        _buildProgressStep(3, 'Reset', _state == 'resetPassword'),
      ],
    );
  }
  
  Widget _buildProgressStep(int step, String label, bool isActive) {
    final theme = Theme.of(context);
    final completedStep = _getStepValue(step) < _getStepValue(_getCurrentStep());
    
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive 
              ? theme.colorScheme.primary
              : completedStep
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
          ),
          child: Center(
            child: completedStep
              ? Icon(
                  Icons.check,
                  color: theme.colorScheme.onPrimaryContainer,
                  size: 16,
                )
              : Text(
                  step.toString(),
                  style: TextStyle(
                    color: isActive 
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive 
              ? theme.colorScheme.primary
              : completedStep
                ? theme.colorScheme.primary.withValues(alpha: 0.7)
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
  
  Widget _buildProgressLine(int step) {
    final theme = Theme.of(context);
    if (_getStepValue(step) < _getStepValue(_getCurrentStep())) {
      return Expanded(
        child: Container(
          height: 2,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: theme.colorScheme.primary,
        ),
      );
    }
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
    );
  }
  
  Widget _buildEmailRequestForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter your email address and we\'ll send you a verification code to reset your password.',
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOtpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'We\'ve sent a verification code to your email. Please enter it below to continue.',
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Verification Code',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _isLoading ? null : _resendOtp,
          icon: const Icon(Icons.refresh),
          label: const Text('Resend Code'),
        ),
      ],
    );
  }

  Widget _buildPasswordResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Create a new secure password for your account.',
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Password must be at least 6 characters long and contain at least one number.',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }
  
  Future<void> _handleSubmit() async {
    if (_state == 'requestEmail' && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    if (_state == 'enterOtp' && _otpController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter the verification code sent to your email.';
      });
      return;
    }
    
    if (_state == 'resetPassword') {
      if (_newPasswordController.text.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Please enter a new password.';
        });
        return;
      }
      
      if (_newPasswordController.text.length < 6) {
        setState(() {
          _errorMessage = 'Password must be at least 6 characters long.';
        });
        return;
      }
      
      if (_newPasswordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = 'Passwords do not match.';
        });
        return;
      }
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      
      if (_state == 'requestEmail') {
        final success = await authViewModel.requestEmail(_emailController.text.trim());
        if (success) {
          setState(() {
            _state = 'enterOtp';
          });
        } else {
          setState(() {
            _errorMessage = authViewModel.errorMessage.isNotEmpty 
              ? authViewModel.errorMessage 
              : 'Failed to send verification code. Please try again.';
          });
        }
      } else if (_state == 'enterOtp') {
        final success = await authViewModel.verifyOtp(_emailController.text.trim(), _otpController.text.trim());
        if (success) {
          setState(() {
            _state = 'resetPassword';
          });
        } else {
          setState(() {
            _errorMessage = authViewModel.errorMessage.isNotEmpty 
              ? authViewModel.errorMessage 
              : 'Invalid verification code. Please try again.';
          });
        }
      } else if (_state == 'resetPassword') {
        final success = await authViewModel.resetPassword(
          _newPasswordController.text.trim(),
        );
        if (success && mounted) {
          _showSuccessAndNavigate();
        } else {
          setState(() {
            _errorMessage = authViewModel.errorMessage.isNotEmpty 
              ? authViewModel.errorMessage 
              : 'Failed to reset password. Please try again.';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _resendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final success = await authViewModel.requestEmail(_emailController.text.trim());
      
      if (success) {
        setState(() {
          _errorMessage = 'A new verification code has been sent to your email.';
        });
      } else {
        setState(() {
          _errorMessage = authViewModel.errorMessage.isNotEmpty 
            ? authViewModel.errorMessage 
            : 'Failed to resend verification code. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _showSuccessAndNavigate() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Password Reset Successful'),
        content: const Text(
          'Your password has been reset successfully. You can now login with your new password.'
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/login');
            },
            child: const Text('Login Now'),
          ),
        ],
      ),
    );
  }
  
  String _getHeaderText() {
    switch (_state) {
      case 'requestEmail':
        return 'Forgot Password';
      case 'enterOtp':
        return 'Verify Your Email';
      case 'resetPassword':
        return 'Reset Your Password';
      default:
        return 'Forgot Password';
    }
  }
  
  String _getButtonText() {
    switch (_state) {
      case 'requestEmail':
        return 'Send Verification Code';
      case 'enterOtp':
        return 'Verify Code';
      case 'resetPassword':
        return 'Reset Password';
      default:
        return 'Continue';
    }
  }
  
  int _getCurrentStep() {
    switch (_state) {
      case 'requestEmail':
        return 1;
      case 'enterOtp':
        return 2;
      case 'resetPassword':
        return 3;
      default:
        return 1;
    }
  }
  
  int _getStepValue(int step) {
    return step;
  }
}