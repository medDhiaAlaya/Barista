import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences sharedPreferences;

  static Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  // get data
  static dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    try {
      if (value is String) return await sharedPreferences.setString(key, value);
      if (value is int) return await sharedPreferences.setInt(key, value);
      if (value is bool) return await sharedPreferences.setBool(key, value);
      return await sharedPreferences.setDouble(key, value);
    } catch (_) {
      throw CouldNotSaveDataException();
    }
  }

  // remove user data (token)
  static Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }
}

class CouldNotSaveDataException implements Exception {}
