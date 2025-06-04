import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/domain/entities/todo.dart';
import 'package:userverse/features/users/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers({
    int skip = 0,
    int limit = 10,
    String? searchQuery,
  });
  Future<List<Post>> getUserPosts(int userId);
  Future<List<Todo>> getUserTodos(int userId);
  Future<void> createLocalPost(Post post);
}
