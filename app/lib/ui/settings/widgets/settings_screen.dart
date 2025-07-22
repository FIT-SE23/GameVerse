import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameverse/ui/settings/view_model/settings_viewmodel.dart';
import 'package:gameverse/ui/shared/theme_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<SettingsViewmodel, ThemeViewModel>(
      builder: (context, settingsViewModel, themeViewModel, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // Privacy Settings
              _buildSectionHeader(context, 'Privacy Settings'),
              _buildPrivacyToggle(
                context,
                'Show Activity',
                'Display your recent gaming activity',
                settingsViewModel.showActivity,
                (value) => settingsViewModel.updateShowActivity(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Friends',
                'Display your friends list',
                settingsViewModel.showFriends,
                (value) => settingsViewModel.updateShowFriends(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Gaming Stats',
                'Display your gaming statistics',
                settingsViewModel.showStats,
                (value) => settingsViewModel.updateShowStats(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Preferences',
                'Display your gaming preferences',
                settingsViewModel.showPreferences,
                (value) => settingsViewModel.updateShowPreferences(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Last Active',
                'Display when you were last active',
                settingsViewModel.showLastActive,
                (value) => settingsViewModel.updateShowLastActive(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Location',
                'Display your location',
                settingsViewModel.showLocation,
                (value) => settingsViewModel.updateShowLocation(value),
              ),
              _buildPrivacyToggle(
                context,
                'Show Bio',
                'Display your bio/about section',
                settingsViewModel.showBio,
                (value) => settingsViewModel.updateShowBio(value),
              ),
          
              const Divider(height: 32),
          
              // App Settings
              _buildSectionHeader(context, 'App Settings'),
              ListTile(
                leading: Icon(
                  themeViewModel.isDarkMode 
                      ? Icons.dark_mode 
                      : Icons.light_mode,
                ),
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark themes'),
                trailing: Switch(
                  value: themeViewModel.isDarkMode,
                  onChanged: (_) => themeViewModel.toggleTheme(),
                ),
                onTap: themeViewModel.toggleTheme,
              ),
              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notifications'),
                subtitle: const Text('Configure notification preferences'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showNotificationSettings(context),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                subtitle: const Text('Choose your preferred language'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showLanguageSettings(context),
              ),
          
              const Divider(height: 32),
          
              // Account Settings
              _buildSectionHeader(context, 'Account Settings'),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Download Data'),
                subtitle: const Text('Download your account data'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showDownloadData(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                subtitle: const Text('Permanently delete your account'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showDeleteAccount(context),
              ),
          
              const Divider(height: 32),
          
              // Support
              _buildSectionHeader(context, 'Support'),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help & FAQ'),
                subtitle: const Text('Get help and find answers'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showHelp(context),
              ),
              ListTile(
                leading: const Icon(Icons.contact_support),
                title: const Text('Contact Support'),
                subtitle: const Text('Get in touch with our support team'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _contactSupport(context),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                subtitle: const Text('App version and information'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => _showAbout(context),
              ),
          
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      onTap: () => onChanged(!value),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // Implement notification settings
  }

  void _showLanguageSettings(BuildContext context) {
    // Implement language settings
  }

  void _showDownloadData(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Data'),
        content: const Text('Your account data will be prepared and sent to your email address.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data download request submitted'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Request Download'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // Implement account deletion
            },
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    // Navigate to help screen
  }

  void _contactSupport(BuildContext context) {
    // Open support contact
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'GameVerse',
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2024 GameVerse. All rights reserved.',
    );
  }
}