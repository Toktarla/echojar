
import 'package:echojar/app/database/src/preferences/app_preferences.dart';
import 'package:echojar/app/database/src/preferences/app_preferences_keys.dart';

class AppConfigManager {
  static final AppConfigManager _instance = AppConfigManager._internal();
  factory AppConfigManager() => _instance;
  AppConfigManager._internal();

  final _prefs = AppPreferences();

  // User name
  Future<String?> getUserName() =>
      _prefs.getString(AppPreferenceKeys.userName);
  Future<void> setUserName(String name) =>
      _prefs.setString(AppPreferenceKeys.userName, name);

  // Onboarding
  Future<bool?> isOnboardingCompleted() =>
      _prefs.getBool(AppPreferenceKeys.onboardingCompleted);
  Future<void> setOnboardingCompleted(bool value) =>
      _prefs.setBool(AppPreferenceKeys.onboardingCompleted, value);

  // Language
  Future<String?> getLanguage() =>
      _prefs.getString(AppPreferenceKeys.languageCode);
  Future<void> setLanguage(String code) =>
      _prefs.setString(AppPreferenceKeys.languageCode, code);

  // Showcases
  Future<bool?> isRootHintShown() =>
      _prefs.getBool(AppPreferenceKeys.isRootHintShown);
  Future<void> setRootHintShown(bool value) =>
      _prefs.setBool(AppPreferenceKeys.isRootHintShown, value);
}
