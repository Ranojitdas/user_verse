import 'package:userverse/features/users/domain/entities/user.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call({int skip = 0, int limit = 10, String? searchQuery}) {
    return repository.getUsers(
      skip: skip,
      limit: limit,
      searchQuery: searchQuery,
    );
  }
}
