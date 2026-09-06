import 'package:flutter/material.dart';
import '../../shared/models/user_model.dart';

/// Lightweight in-memory app state (no backend yet). Holds the signed-in
/// role, theme mode, and favorited property ids for the session.
class AppSession extends ChangeNotifier {
  AppSession._();
  static final AppSession instance = AppSession._();

  UserRole? _role;
  UserRole? get role => _role;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  final Set<String> _favoriteIds = {'p1', 'p4', 'p9'};
  Set<String> get favoriteIds => _favoriteIds;

  void signIn(UserRole role) {
    _role = role;
    notifyListeners();
  }

  void signOut() {
    _role = null;
    notifyListeners();
  }

  void toggleFavorite(String propertyId) {
    if (_favoriteIds.contains(propertyId)) {
      _favoriteIds.remove(propertyId);
    } else {
      _favoriteIds.add(propertyId);
    }
    notifyListeners();
  }

  bool isFavorite(String propertyId) => _favoriteIds.contains(propertyId);

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
