import 'package:userverse/features/users/data/datasources/user_local_data_source.dart';
import 'package:userverse/features/users/data/datasources/user_remote_data_source.dart';
import 'package:userverse/features/users/data/datasources/post_local_data_source.dart';
import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/domain/entities/todo.dart';
import 'package:userverse/features/users/domain/entities/user.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';
import 'package:userverse/features/users/data/exceptions/api_exception.dart';
import 'package:userverse/features/users/data/models/post_model.dart';

class RepositoryException implements Exception {
  final String message;
  final String? code;

  RepositoryException(this.message, {this.code});

  @override
  String toString() =>
      'RepositoryException: $message${code != null ? ' (Code: $code)' : ''}';
}

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;
  final PostLocalDataSource postLocalDataSource;

  UserRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.postLocalDataSource,
  });

  @override
  Future<List<User>> getUsers({
    int skip = 0,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final users = await remoteDataSource.getUsers(
        skip: skip,
        limit: limit,
        searchQuery: searchQuery,
      );
      if (skip == 0) {
        await localDataSource.cacheUsers(users);
      }
      return users;
    } on ApiException catch (e) {
      if (skip == 0) {
        final cachedUsers = await localDataSource.getCachedUsers();
        if (cachedUsers.isNotEmpty) {
          return cachedUsers;
        }
      }
      throw RepositoryException(
        'Failed to fetch users: ${e.message}',
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw RepositoryException('Failed to fetch users: ${e.toString()}');
    }
  }

  @override
  Future<List<Post>> getUserPosts(int userId) async {
    try {
      final remotePosts = await remoteDataSource.getUserPosts(userId);
      final localPosts = await postLocalDataSource.getCachedPosts(userId);
      return [...remotePosts, ...localPosts];
    } on ApiException catch (e) {
      final localPosts = await postLocalDataSource.getCachedPosts(userId);
      if (localPosts.isNotEmpty) {
        return localPosts;
      }
      throw RepositoryException(
        'Failed to fetch user posts: ${e.message}',
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw RepositoryException('Failed to fetch user posts: ${e.toString()}');
    }
  }

  @override
  Future<void> createLocalPost(Post post) async {
    try {
      await postLocalDataSource.cachePost(
        PostModel(
          id: post.id,
          userId: post.userId,
          title: post.title,
          body: post.body,
        ),
      );
    } catch (e) {
      throw RepositoryException('Failed to save post locally: ${e.toString()}');
    }
  }

  @override
  Future<List<Todo>> getUserTodos(int userId) async {
    try {
      final todos = await remoteDataSource.getUserTodos(userId);
      return todos;
    } on ApiException catch (e) {
      throw RepositoryException(
        'Failed to fetch user todos: ${e.message}',
        code: e.statusCode?.toString(),
      );
    } catch (e) {
      throw RepositoryException('Failed to fetch user todos: ${e.toString()}');
    }
  }
}
