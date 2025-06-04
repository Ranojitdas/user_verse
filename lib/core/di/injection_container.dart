import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:userverse/features/users/data/datasources/user_local_data_source.dart';
import 'package:userverse/features/users/data/datasources/user_remote_data_source.dart';
import 'package:userverse/features/users/data/datasources/post_local_data_source.dart';
import 'package:userverse/features/users/data/repositories/user_repository_impl.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';
import 'package:userverse/features/users/domain/usecases/get_users.dart';
import 'package:userverse/features/users/domain/usecases/get_user_posts.dart';
import 'package:userverse/features/users/domain/usecases/get_user_todos.dart';
import 'package:userverse/features/users/presentation/bloc/users_bloc.dart';
import 'package:userverse/core/theme/theme_bloc.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      postLocalDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUserPosts(sl()));
  sl.registerLazySingleton(() => GetUserTodos(sl()));

  // Bloc
  sl.registerFactory(
    () => UsersBloc(
      getUsers: sl(),
      getUserPosts: sl(),
      getUserTodos: sl(),
      userRepository: sl(),
    ),
  );

  // Theme Bloc
  sl.registerFactory(() => ThemeBloc(sharedPreferences: sl()));
}
