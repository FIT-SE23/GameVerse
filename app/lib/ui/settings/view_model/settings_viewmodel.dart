import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
// import 'package:shared_preferences/shared_preferences.dart';

class SettingsViewModel extends ChangeNotifier {
  // Privacy settings
  bool _showActivity = true;
  bool get showActivity => _showActivity;

  bool _showFriends = true;
  bool get showFriends => _showFriends;

  bool _showStats = true;
  bool get showStats => _showStats;

  bool _showPreferences = true;
  bool get showPreferences => _showPreferences;

  bool _showLastActive = true;
  bool get showLastActive => _showLastActive;

  bool _showLocation = true;
  bool get showLocation => _showLocation;

  bool _showBio = true;
  bool get showBio => _showBio;

  String _downloadPath = '';
  String get downloadPath => _downloadPath;

  SettingsViewModel() {
    initialize();
  }

  Future<void> initialize() async {
    _downloadPath = await _getDefaultDownloadPath();
    notifyListeners();
  }


  Future<String> _getDefaultDownloadPath() async {
    if (Platform.isWindows) {
      final userProfile = Platform.environment['USERPROFILE'];
      return path.join(userProfile!, 'Documents', 'GameVerse', 'Games');
    } else if (Platform.isMacOS) {
      final home = Platform.environment['HOME'];
      return path.join(home!, 'Documents', 'GameVerse', 'Games');
    } else if (Platform.isLinux) {
      final home = Platform.environment['HOME'];
      return path.join(home!, 'GameVerse', 'Games');
    }
    return path.join(Directory.current.path, 'GameVerse', 'Games');
  }

  Future<void> setDownloadPath(String newPath) async {
    _downloadPath = newPath;
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.setString('download_path', newPath);
    
    // Create directory if it doesn't exist
    final directory = Directory(newPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    notifyListeners();
  }

    // Privacy settings updates
  void updateShowActivity(bool value) {
    _showActivity = value;
    notifyListeners();
  }

  void updateShowFriends(bool value) {
    _showFriends = value;
    notifyListeners();
  }

  void updateShowStats(bool value) {
    _showStats = value;
    notifyListeners();
  }

  void updateShowPreferences(bool value) {
    _showPreferences = value;
    notifyListeners();
  }

  void updateShowLastActive(bool value) {
    _showLastActive = value;
    notifyListeners();
  }

  void updateShowLocation(bool value) {
    _showLocation = value;
    notifyListeners();
  }

  void updateShowBio(bool value) {
    _showBio = value;
    notifyListeners();
  }
}