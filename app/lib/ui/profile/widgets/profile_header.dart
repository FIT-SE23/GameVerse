import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:gameverse/domain/models/user_model/user_model.dart';
import 'package:gameverse/ui/profile/view_model/profile_viewmodel.dart';
import 'status_card.dart';
import 'edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileViewModel profileViewModel;
  final UserModel user;
  final bool isOwnProfile;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.profileViewModel,
    this.isOwnProfile = true,
  });

  void _showEditProfileModal(BuildContext context) {
    // Navigate to edit profile screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          user: user,
          profileViewModel: profileViewModel,
        ),
      ),
    );
  }

  void _addFriend(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: Text('Send friend request to ${user.username}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement friend request logic
              // profileViewModel.sendFriendRequest(user.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Friend request sent to ${user.username}'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    // Navigate to messaging screen
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        // builder: (context, scrollController) => MessageModal(
        //   user: user,
        //   scrollController: scrollController,
        // ),
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                'Messaging ${user.username}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Implement message input and list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: 20, // Placeholder for messages
                  itemBuilder: (context, index) => ListTile(
                    title: Text('Message $index'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.8),
            theme.colorScheme.primary.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(isWideScreen ? 32 : 24),
          child: Column(
            children: [
              // Profile Image and Basic Info
              Row(
                children: [
                  // Profile Avatar
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: isWideScreen ? 60 : 50,
                        backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                        backgroundImage: profileViewModel.profileImageUrl != null
                            ? NetworkImage(profileViewModel.profileImageUrl!)
                            : null,
                        child: profileViewModel.profileImageUrl == null
                            ? Icon(
                                Icons.person,
                                size: isWideScreen ? 60 : 50,
                                color: theme.colorScheme.onPrimary,
                              )
                            : null,
                      ),
                      if (isOwnProfile)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.onPrimary,
                                width: 2,
                              ),
                            ),
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: profileViewModel.isOnline ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.colorScheme.onPrimary,
                                  width: 2,
                                ),
                              ),
                            )
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(width: 24),

                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.username,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Online status indicator
                            if (isOwnProfile) ...[
                              // Edit Profile Button
                              ElevatedButton.icon(
                                onPressed: () => _showEditProfileModal(context),
                                icon: const Icon(Icons.edit),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.onPrimary,
                                  foregroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                              ),
                            ] else ...[
                              // Add Friend Button
                              ElevatedButton.icon(
                                onPressed: () => _addFriend(context),
                                icon: const Icon(Icons.person_add),
                                label: const Text('Add Friend'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.onPrimary,
                                  foregroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Message Button
                              OutlinedButton.icon(
                                onPressed: () => _sendMessage(context),
                                icon: const Icon(Icons.message),
                                label: const Text('Message'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: theme.colorScheme.onPrimary,
                                  side: BorderSide(color: theme.colorScheme.onPrimary),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 16,
                                    color: theme.colorScheme.onSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Type: ${user.type.toUpperCase()}',
                                    style: TextStyle(
                                      color: _getStatusColor(user.type),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Publisher registration if user is not a publisher
                            if (user.type != 'publisher') ...[
                              ElevatedButton(
                                onPressed: () {
                                  // Navigate to publisher registration
                                  context.push('/publisher-registration');
                                },
                                // Style must border round
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                ),
                                child: const Text('Become a Publisher'),
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Stats Row
              if (MediaQuery.sizeOf(context).width > 600) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatusCard(
                      icon: Icons.games,
                      label: 'Games Owned',
                      value: profileViewModel.gamesOwned.toString(),
                    ),
                    StatusCard(
                      icon: Icons.schedule,
                      label: 'Hours Played',
                      value: profileViewModel.totalHoursPlayed.toStringAsFixed(0),
                    ),
                    StatusCard(
                      icon: Icons.emoji_events,
                      label: 'Achievements',
                      value: profileViewModel.totalAchievements.toString(),
                    ),
                    StatusCard(
                      icon: Icons.favorite,
                      label: 'Wishlist',
                      value: profileViewModel.wishlistCount.toString(),
                    ),
                  ],
                ),
              ] else ...[
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusCard(
                          icon: Icons.games,
                          label: 'Games Owned',
                          value: profileViewModel.gamesOwned.toString(),
                        ),
                        StatusCard(
                          icon: Icons.schedule,
                          label: 'Hours Played',
                          value: profileViewModel.totalHoursPlayed.toStringAsFixed(0),
                        )
                      ]
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatusCard(
                          icon: Icons.emoji_events,
                          label: 'Achievements',
                          value: profileViewModel.totalAchievements.toString(),
                        ),
                        StatusCard(
                          icon: Icons.favorite,
                          label: 'Wishlist',
                          value: profileViewModel.wishlistCount.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
  Color _getStatusColor(String type) {
    switch (type.toLowerCase()) {
      case 'publisher':
        return Colors.orange;
      case 'operator':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}