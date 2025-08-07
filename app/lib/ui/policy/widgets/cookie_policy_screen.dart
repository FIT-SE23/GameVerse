import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class CookiePolicyScreen extends StatelessWidget {
  const CookiePolicyScreen({super.key});

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
                  'Cookie Policy',
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
                      '1. What Are Cookies?',
                      'Cookies are small text files that are stored on your device when you visit our website. They help us provide you with a better experience by remembering your preferences and analyzing how you use our platform.',
                    ),
                    _buildCookieTypes(context),
                    _buildSection(
                      context,
                      '3. How We Use Cookies',
                      'We use cookies to authenticate users, remember your preferences, analyze website traffic, personalize content, and improve our services.',
                    ),
                    _buildSection(
                      context,
                      '4. Third-Party Cookies',
                      'We may allow third-party service providers to place cookies on your device for analytics, advertising, and social media features. These parties have their own privacy policies.',
                    ),
                    _buildSection(
                      context,
                      '5. Managing Cookies',
                      'You can control and delete cookies through your browser settings. However, disabling certain cookies may affect the functionality of GameVerse.',
                    ),
                    _buildBrowserInstructions(context),
                    _buildSection(
                      context,
                      '7. Updates to This Policy',
                      'We may update this Cookie Policy from time to time. Any changes will be posted on this page with an updated revision date.',
                    ),
                    _buildSection(
                      context,
                      '8. Contact Us',
                      'If you have questions about our use of cookies, please contact us at cookies@gameverse.com',
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
          'GameVerse Cookie Policy',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'This Cookie Policy explains how GameVerse uses cookies and similar technologies to enhance your experience on our platform.',
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

  Widget _buildCookieTypes(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '2. Types of Cookies We Use',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          _buildCookieType(context, 'Essential Cookies', 'Required for basic website functionality, security, and user authentication.'),
          _buildCookieType(context, 'Performance Cookies', 'Help us understand how visitors interact with our website by collecting anonymous information.'),
          _buildCookieType(context, 'Functionality Cookies', 'Remember your preferences and settings to enhance your experience.'),
          _buildCookieType(context, 'Targeting Cookies', 'Used to deliver relevant advertisements and measure their effectiveness.'),
        ],
      ),
    );
  }

  Widget _buildCookieType(BuildContext context, String type, String description) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowserInstructions(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '6. Browser Settings',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You can manage cookies in your browser settings:',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: 12),
          _buildBrowserStep(context, 'Chrome', 'Settings > Privacy and security > Cookies and other site data'),
          _buildBrowserStep(context, 'Firefox', 'Settings > Privacy & Security > Cookies and Site Data'),
          _buildBrowserStep(context, 'Safari', 'Preferences > Privacy > Manage Website Data'),
          _buildBrowserStep(context, 'Edge', 'Settings > Cookies and site permissions > Cookies and site data'),
        ],
      ),
    );
  }

  Widget _buildBrowserStep(BuildContext context, String browser, String instruction) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              browser,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              instruction,
              style: theme.textTheme.bodyMedium,
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
            Icons.cookie,
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