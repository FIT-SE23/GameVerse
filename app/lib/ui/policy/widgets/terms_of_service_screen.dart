import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Terms of Service',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    _buildSection(
                      context,
                      '1. Acceptance of Terms',
                      'By creating an account or using GameVerse, you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.',
                    ),
                    _buildSection(
                      context,
                      '2. User Accounts',
                      'You are responsible for maintaining the security of your account and password. GameVerse cannot and will not be liable for any loss or damage from your failure to comply with this security obligation.',
                    ),
                    _buildSection(
                      context,
                      '3. Game Content and Purchases',
                      'All games and content available through GameVerse are licensed, not sold. Your purchase grants you a personal, non-transferable license to use the content according to the terms specified by the publisher.',
                    ),
                    _buildSection(
                      context,
                      '4. Community Guidelines',
                      'Users must respect other community members. Harassment, spam, cheating, or any form of abuse will result in account suspension or termination.',
                    ),
                    _buildSection(
                      context,
                      '5. Intellectual Property',
                      'GameVerse and its content are protected by copyright, trademark, and other intellectual property laws. You may not reproduce, distribute, or create derivative works without permission.',
                    ),
                    _buildSection(
                      context,
                      '6. Privacy and Data Collection',
                      'Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your information.',
                    ),
                    _buildSection(
                      context,
                      '7. Limitation of Liability',
                      'GameVerse is provided "as is" without warranties of any kind. We shall not be liable for any indirect, incidental, special, or consequential damages.',
                    ),
                    _buildSection(
                      context,
                      '8. Termination',
                      'We reserve the right to terminate or suspend your account at any time for violations of these terms or for any other reason at our sole discretion.',
                    ),
                    _buildSection(
                      context,
                      '9. Changes to Terms',
                      'We may update these terms from time to time. Continued use of GameVerse after changes constitutes acceptance of the new terms.',
                    ),
                    _buildSection(
                      context,
                      '10. Contact Information',
                      'If you have questions about these Terms of Service, please contact us at legal@gameverse.com',
                    ),
                    const SizedBox(height: 32),
                    _buildLastUpdated(context),
                    const SizedBox(height: 64),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: PageFooter()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GameVerse Terms of Service',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Please read these terms carefully before using GameVerse. These terms govern your use of our gaming platform and services.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.update,
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'Last updated: January 1, 2025',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}