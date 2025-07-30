import 'package:flutter/material.dart';


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