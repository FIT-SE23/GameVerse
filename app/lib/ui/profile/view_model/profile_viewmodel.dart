import 'package:flutter/material.dart';
import 'package:gameverse/data/repositories/game_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;

  ProfileViewModel({required GameRepository gameRepository})
      : _gameRepository = gameRepository {
    _loadProfileData();
  }


  // Profile Data
  String? _profileImageUrl;
  String? get profileImageUrl => _profileImageUrl;

  final bool isOnline = true;
  bool get onlineStatus => isOnline;

  int _gamesOwned = 0;
  int get gamesOwned => _gamesOwned;

  final double _totalHoursPlayed = 0;
  double get totalHoursPlayed => _totalHoursPlayed;

  final int _totalAchievements = 0;
  int get totalAchievements => _totalAchievements;

  int _wishlistCount = 0;
  int get wishlistCount => _wishlistCount;

  String _favoriteGenre = 'Action RPG';
  String get favoriteGenre => _favoriteGenre;

  String _playtimePreference = 'Evening (6-12 PM)';
  String get playtimePreference => _playtimePreference;

  String _preferredPlatform = 'PC Gaming';
  String get preferredPlatform => _preferredPlatform;

  final int _friendsCount = 23;
  int get friendsCount => _friendsCount;

  List<GameFriend> _friends = [];
  List<GameFriend> get friends => _friends;

  List<ProfileActivity> _recentActivities = [];
  List<ProfileActivity> get recentActivities => _recentActivities;

  String _bio = 'Passionate gamer who loves RPGs and strategy games. Always up for a co-op adventure!';
  String get bio => _bio;

  void _loadProfileData() {
    _gamesOwned = _gameRepository.getOwnedGamesCount();
    _wishlistCount = _gameRepository.getWishlistCount();

    // Load mock friends
    _friends = [
      GameFriend(name: 'Alex', isOnline: true),
      GameFriend(name: 'Sarah', isOnline: false),
      GameFriend(name: 'Mike', isOnline: true),
      GameFriend(name: 'Emma', isOnline: false),
      GameFriend(name: 'John', isOnline: true),
    ];

    // Load mock recent activities
    _recentActivities = [
      ProfileActivity(
        icon: Icons.videogame_asset,
        title: 'Played Counter-Strike 2',
        description: 'Achieved a new personal best score',
        timeAgo: '2 hours ago',
      ),
      ProfileActivity(
        icon: Icons.emoji_events,
        title: 'Unlocked Achievement',
        description: 'Master Strategist in Dota 2',
        timeAgo: '1 day ago',
      ),
      ProfileActivity(
        icon: Icons.favorite,
        title: 'Added to Wishlist',
        description: 'Cyberpunk 2077: Phantom Liberty',
        timeAgo: '3 days ago',
      ),
      ProfileActivity(
        icon: Icons.group_add,
        title: 'New Friend',
        description: 'Connected with PlayerX',
        timeAgo: '1 week ago',
      ),
    ];
    notifyListeners();
  }

  void updateProfileImage(String? imageUrl) {
    _profileImageUrl = imageUrl;
    notifyListeners();
  }

  void updateFavoriteGenre(String genre) {
    _favoriteGenre = genre;
    notifyListeners();
  }

  void updatePlaytimePreference(String preference) {
    _playtimePreference = preference;
    notifyListeners();
  }

  void updatePreferredPlatform(String platform) {
    _preferredPlatform = platform;
    notifyListeners();
  }

  void updateBio(String bio) {
    _bio = bio;
    notifyListeners();
  }

  // Friend actions
  void sendFriendRequest(String userId) {
    // Implement friend request logic
    notifyListeners();
  }

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                // Implement gallery picker
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                // Implement camera
                Navigator.pop(context);
              },
            ),
            if (profileImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Photo'),
                onTap: () {
                  updateProfileImage(null);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class GameFriend {
  final String name;
  final bool isOnline;

  GameFriend({required this.name, required this.isOnline});
}

class ProfileActivity {
  final IconData icon;
  final String title;
  final String description;
  final String timeAgo;

  ProfileActivity({
    required this.icon,
    required this.title,
    required this.description,
    required this.timeAgo,
  });
}