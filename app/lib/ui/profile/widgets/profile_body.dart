import 'package:flutter/material.dart';

import 'package:gameverse/domain/models/user_model/user_model.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';

class ProfileBody extends StatelessWidget {
  final UserModel user;
  final ProfileViewModel profileViewModel;

  const ProfileBody({
    super.key,
    required this.user,
    required this.profileViewModel,
  });

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: EdgeInsets.all(isWideScreen ? 32 : 16),
      child: Column(
        children: [
          // Recent Activity
          _buildSectionCard(
            context,
            title: 'Bio',
            icon: Icons.info,
            child: Text(
              profileViewModel.bio.isNotEmpty
                  ? profileViewModel.bio
                  : 'No bio available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          const SizedBox(height: 24),

          // Gaming Preferences
          _buildSectionCard(
            context,
            title: 'Gaming Preferences',
            icon: Icons.settings,
            child: Column(
              children: [
                _buildPreferenceRow(
                  context,
                  'Favorite Genre',
                  profileViewModel.favoriteGenre,
                  Icons.category,
                ),
                _buildPreferenceRow(
                  context,
                  'Playtime Preference',
                  profileViewModel.playtimePreference,
                  Icons.schedule,
                ),
                _buildPreferenceRow(
                  context,
                  'Platform',
                  profileViewModel.preferredPlatform,
                  Icons.computer,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Friends Section
          _buildSectionCard(
            context,
            title: 'Gaming Friends',
            icon: Icons.group,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${profileViewModel.friendsCount} Friends',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => _showFriendsModal(context),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: profileViewModel.friends.length,
                    itemBuilder: (context, index) {
                      final friend = profileViewModel.friends[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: Text(
                                friend.name[0].toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              friend.name,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Account Actions
          _buildSectionCard(
            context,
            title: 'Account Settings',
            icon: Icons.account_circle,
            child: Column(
              children: [
                _buildActionTile(
                  context,
                  'Privacy Settings',
                  Icons.privacy_tip,
                  () => _showPrivacySettings(context),
                ),
                _buildActionTile(
                  context,
                  'Notification Preferences',
                  Icons.notifications,
                  () => _showNotificationSettings(context),
                ),
                _buildActionTile(
                  context,
                  'Data & Storage',
                  Icons.storage,
                  () => _showDataSettings(context),
                ),
                _buildActionTile(
                  context,
                  'Help & Support',
                  Icons.help,
                  () => _showHelpSupport(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildSectionCard(BuildContext context, {
  required String title,
  required IconData icon,
  required Widget child,
}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ),
  );
}

Widget _buildPreferenceRow(BuildContext context, String label, String value, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
  return ListTile(
    leading: Icon(icon),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}

void _showFriendsModal(BuildContext context) {
  // Implement friends list
}

void _showPrivacySettings(BuildContext context) {
  // Implement privacy settings
}

void _showNotificationSettings(BuildContext context) {
  // Implement notification settings
}

void _showDataSettings(BuildContext context) {
  // Implement data settings
}

void _showHelpSupport(BuildContext context) {
  // Implement help & support
}