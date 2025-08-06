import 'package:flutter/material.dart';
import 'package:gameverse/ui/shared/widgets/page_footer.dart';

class EulaScreen extends StatelessWidget {
  const EulaScreen({super.key});

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
                  'End User License Agreement (EULA)',
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
                      '1. License Grant',
                      'GameVerse grants you a personal, non-exclusive, non-transferable license to use the GameVerse application and access our gaming platform, subject to the terms of this agreement.',
                    ),
                    _buildSection(
                      context,
                      '2. Permitted Uses',
                      'You may use GameVerse to browse, purchase, download, and play games in accordance with the terms specified for each game. You may also participate in community features.',
                    ),
                    _buildSection(
                      context,
                      '3. Restrictions',
                      'You may not: copy, modify, or distribute the GameVerse software; reverse engineer or attempt to extract source code; use the platform for illegal activities; create derivative works; or circumvent security measures.',
                    ),
                    _buildSection(
                      context,
                      '4. Game Content Licensing',
                      'Games and content available through GameVerse are licensed from their respective publishers. Each game may have additional terms and conditions that apply.',
                    ),
                    _buildSection(
                      context,
                      '5. Account Requirements',
                      'You must create an account to access most features of GameVerse. You are responsible for maintaining the confidentiality of your account credentials.',
                    ),
                    _buildSection(
                      context,
                      '6. Content Ownership',
                      'GameVerse retains ownership of the platform, software, and related intellectual property. Game publishers retain ownership of their respective games and content.',
                    ),
                    _buildSection(
                      context,
                      '7. Updates and Modifications',
                      'We may update the GameVerse application from time to time. These updates may include new features, bug fixes, or security improvements.',
                    ),
                    _buildSection(
                      context,
                      '8. Termination',
                      'This license is effective until terminated. We may terminate your license if you breach any terms of this agreement. Upon termination, you must cease all use of GameVerse.',
                    ),
                    _buildSection(
                      context,
                      '9. Disclaimer of Warranties',
                      'GameVerse is provided "as is" without warranties of any kind, either express or implied, including but not limited to merchantability and fitness for a particular purpose.',
                    ),
                    _buildSection(
                      context,
                      '10. Limitation of Liability',
                      'In no event shall GameVerse be liable for any indirect, incidental, special, or consequential damages arising out of or in connection with your use of the platform.',
                    ),
                    _buildSection(
                      context,
                      '11. Governing Law',
                      'This agreement shall be governed by and construed in accordance with the laws of Vietnam, without regard to conflict of law principles.',
                    ),
                    _buildSection(
                      context,
                      '12. Contact Information',
                      'If you have questions about this EULA, please contact us at legal@gameverse.com',
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
          'GameVerse Store End User License Agreement',
          style: theme.textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: theme.colorScheme.onPrimaryContainer,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This End User License Agreement (EULA) governs your use of the GameVerse application and platform.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
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
            Icons.gavel,
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