import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userverse/features/users/data/models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts(int userId);
  Future<void> cachePost(PostModel post);
}

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_POSTS_KEY = 'CACHED_POSTS';

  PostLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<PostModel>> getCachedPosts(int userId) async {
    final jsonString = sharedPreferences.getString(CACHED_POSTS_KEY);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final allPosts =
          jsonList.map((json) => PostModel.fromJson(json)).toList();
      return allPosts.where((post) => post.userId == userId).toList();
    }
    return [];
  }

  @override
  Future<void> cachePost(PostModel post) async {
    final jsonString = sharedPreferences.getString(CACHED_POSTS_KEY);
    List<dynamic> postsJson = [];

    if (jsonString != null) {
      postsJson = json.decode(jsonString);
    }

    postsJson.add(post.toJson());
    await sharedPreferences.setString(CACHED_POSTS_KEY, json.encode(postsJson));
  }
}
