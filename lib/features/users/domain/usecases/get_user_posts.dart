import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';

class GetUserPosts {
  final UserRepository repository;

  GetUserPosts(this.repository);

  Future<List<Post>> call(int userId) {
    return repository.getUserPosts(userId);
  }
}
