import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userverse/features/users/data/models/user_model.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getCachedUsers();
  Future<void> cacheUsers(List<UserModel> users);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_USERS_KEY = 'CACHED_USERS';

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<UserModel>> getCachedUsers() async {
    final jsonString = sharedPreferences.getString(CACHED_USERS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => UserModel.fromJson(json)).toList();
    }
    return [];
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) async {
    final jsonList = users.map((user) => user.toJson()).toList();
    await sharedPreferences.setString(CACHED_USERS_KEY, json.encode(jsonList));
  }
}
