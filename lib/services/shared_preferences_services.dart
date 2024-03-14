import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  late SharedPreferences _preferences;

  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  factory SharedPreferencesService() => _instance;

  SharedPreferencesService._internal();

  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  Future<void> init() async {
    if (!_isInitialized) {
      _preferences = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // Keys
  static const String _onLoginKey = "onlogin";
  static const String _displayNameKey = "displayName";
  static const String _emailKey = "email";
  static const String _photoURLKey = "photoURL";

  // Login
  Future<void> saveOnLogin(bool value) async {
    await _preferences.setBool(_onLoginKey, value);
  }

  Future<bool?> getOnLogin() async {
    return _preferences.getBool(_onLoginKey);
  }

  // Display Name
  Future<void> saveDisplayName(String value) async {
    await _preferences.setString(_displayNameKey, value);
  }

  Future<String?> getDisplayName() async {
    return _preferences.getString(_displayNameKey);
  }

  // Email
  Future<void> saveEmail(String value) async {
    await _preferences.setString(_emailKey, value);
  }

  Future<String?> getEmail() async {
    return _preferences.getString(_emailKey);
  }

  // Photo URL
  Future<void> savePhotoURL(String value) async {
    await _preferences.setString(_photoURLKey, value);
  }

  Future<String?> getPhotoURL() async {
    return _preferences.getString(_photoURLKey);
  }
}
