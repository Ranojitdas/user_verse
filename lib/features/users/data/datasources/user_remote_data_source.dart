import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:userverse/features/users/data/models/post_model.dart';
import 'package:userverse/features/users/data/models/todo_model.dart';
import 'package:userverse/features/users/data/models/user_model.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers({
    int skip = 0,
    int limit = 10,
    String? searchQuery,
  });
  Future<List<PostModel>> getUserPosts(int userId);
  Future<List<TodoModel>> getUserTodos(int userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  UserRemoteDataSourceImpl({
    http.Client? client,
    this.baseUrl = 'https://dummyjson.com',
  }) : client = client ?? http.Client();

  @override
  Future<List<UserModel>> getUsers({
    int skip = 0,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final queryParams = {
        'skip': skip.toString(),
        'limit': limit.toString(),
        if (searchQuery != null && searchQuery.isNotEmpty) 'q': searchQuery,
      };

      final uri = Uri.parse(
        '$baseUrl/users',
      ).replace(queryParameters: queryParams);
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> usersJson = data['users'];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch users',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch users: ${e.toString()}');
    }
  }

  @override
  Future<List<PostModel>> getUserPosts(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/posts/user/$userId');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> postsJson = data['posts'];
        return postsJson.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch user posts',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch user posts: ${e.toString()}');
    }
  }

  @override
  Future<List<TodoModel>> getUserTodos(int userId) async {
    try {
      final uri = Uri.parse('$baseUrl/todos/user/$userId');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> todosJson = data['todos'];
        return todosJson.map((json) => TodoModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          'Failed to fetch user todos',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to fetch user todos: ${e.toString()}');
    }
  }
}
