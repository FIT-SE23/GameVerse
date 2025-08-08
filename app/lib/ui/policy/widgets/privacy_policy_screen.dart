import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                  'Privacy Policy',
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
                        '1. Information We Collect',
                        'We collect information you provide directly to us, such as when you create an account, make purchases, or contact us. This includes your name, email address, username, and payment information.',
                      ),
                      _buildSection(
                        context,
                        '2. How We Use Your Information',
                        'We use your information to provide, maintain, and improve our services, process transactions, send communications, and ensure platform security.',
                      ),
                      _buildSection(
                        context,
                        '3. Information Sharing',
                        'We do not sell or rent your personal information to third parties. We may share information with service providers, for legal compliance, or to protect our rights and users.',
                      ),
                      _buildSection(
                        context,
                        '4. Data Security',
                        'We implement appropriate security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                      ),
                      _buildSection(
                        context,
                        '5. Cookies and Tracking',
                        'We use cookies and similar technologies to enhance your experience, analyze usage, and provide personalized content. See our Cookie Policy for more details.',
                      ),
                      _buildSection(
                        context,
                        '6. Third-Party Services',
                        'Our platform may integrate with third-party services like payment processors and social media platforms. These services have their own privacy policies.',
                      ),
                      _buildSection(
                        context,
                        '7. Data Retention',
                        'We retain your personal information for as long as necessary to provide our services and comply with legal obligations.',
                      ),
                      _buildSection(
                        context,
                        '8. Your Rights',
                        'You have the right to access, update, or delete your personal information. You may also opt out of certain communications and data processing.',
                      ),
                      _buildSection(
                        context,
                        '9. Children\'s Privacy',
                        'GameVerse is not intended for children under 13. We do not knowingly collect personal information from children under 13.',
                      ),
                      _buildSection(
                        context,
                        '10. International Users',
                        'If you are accessing GameVerse from outside Vietnam, your information may be transferred to and processed in Vietnam.',
                      ),
                      _buildSection(
                        context,
                        '11. Contact Us',
                        'If you have questions about this Privacy Policy, please contact us at privacy@gameverse.com',
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
          'GameVerse Privacy Policy',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This Privacy Policy describes how GameVerse collects, uses, and protects your personal information when you use our gaming platform.',
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
            Icons.security,
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