import 'package:userverse/features/users/domain/entities/todo.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';

class GetUserTodos {
  final UserRepository repository;

  GetUserTodos(this.repository);

  Future<List<Todo>> call(int userId) {
    return repository.getUserTodos(userId);
  }
}
