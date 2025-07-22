import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/user_model/user_model.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;
  final ProfileViewModel profileViewModel;

  const EditProfileScreen({
    super.key,
    required this.user,
    required this.profileViewModel,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String? _selectedGenre;
  String? _selectedPlatform;
  String? _selectedPlaytime;
  // ProfileViewModel for image handling
  late ProfileViewModel profileViewModel;

  final List<String> _genres = [
    'Action RPG', 'Strategy', 'FPS', 'MMORPG', 'Racing',
    'Sports', 'Simulation', 'Adventure', 'Horror', 'Indie'
  ];

  final List<String> _platforms = [
    'PC Gaming', 'PlayStation', 'Xbox', 'Nintendo Switch', 'Mobile Gaming'
  ];

  final List<String> _playtimes = [
    'Morning (6-12 AM)', 'Afternoon (12-6 PM)', 
    'Evening (6-12 PM)', 'Night (12-6 AM)', 'Weekends Only'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _bioController = TextEditingController(text: widget.profileViewModel.bio);
    _selectedGenre = widget.profileViewModel.favoriteGenre;
    _selectedPlatform = widget.profileViewModel.preferredPlatform;
    _selectedPlaytime = widget.profileViewModel.playtimePreference;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    // Update profile data
    widget.profileViewModel.updateFavoriteGenre(_selectedGenre ?? '');
    widget.profileViewModel.updatePreferredPlatform(_selectedPlatform ?? '');
    widget.profileViewModel.updatePlaytimePreference(_selectedPlaytime ?? '');
    // widget.profileViewModel.updateBio(_bioController.text);

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    context.pop(); // Close the edit profile screen
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    profileViewModel = widget.profileViewModel;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Section
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  backgroundImage: widget.profileViewModel.profileImageUrl != null
                      ? NetworkImage(widget.profileViewModel.profileImageUrl!)
                      : null,
                  child: widget.profileViewModel.profileImageUrl == null
                      ? const Icon(Icons.person, size: 60)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () {
                        profileViewModel.showImagePicker(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Basic Info
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Basic Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Tell others about yourself...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Gaming Preferences
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gaming Preferences',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedGenre,
                    decoration: const InputDecoration(
                      labelText: 'Favorite Genre',
                      border: OutlineInputBorder(),
                    ),
                    items: _genres.map((genre) => DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedGenre = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPlatform,
                    decoration: const InputDecoration(
                      labelText: 'Preferred Platform',
                      border: OutlineInputBorder(),
                    ),
                    items: _platforms.map((platform) => DropdownMenuItem(
                      value: platform,
                      child: Text(platform),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedPlatform = value),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPlaytime,
                    decoration: const InputDecoration(
                      labelText: 'Preferred Playtime',
                      border: OutlineInputBorder(),
                    ),
                    items: _playtimes.map((time) => DropdownMenuItem(
                      value: time,
                      child: Text(time),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedPlaytime = value),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Save Button and Cancel Button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}