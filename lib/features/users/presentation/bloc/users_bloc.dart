import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/domain/entities/todo.dart';
import 'package:userverse/features/users/domain/entities/user.dart';
import 'package:userverse/features/users/domain/usecases/get_users.dart';
import 'package:userverse/features/users/domain/usecases/get_user_posts.dart';
import 'package:userverse/features/users/domain/usecases/get_user_todos.dart';
import 'package:userverse/features/users/domain/repositories/user_repository.dart';

// Events
abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends UsersEvent {
  final int skip;
  final int limit;
  final String? searchQuery;

  const LoadUsers({this.skip = 0, this.limit = 10, this.searchQuery});

  @override
  List<Object?> get props => [skip, limit, searchQuery];
}

class LoadUserPosts extends UsersEvent {
  final int userId;

  const LoadUserPosts(this.userId);

  @override
  List<Object?> get props => [userId];
}

class LoadUserTodos extends UsersEvent {
  final int userId;

  const LoadUserTodos(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddLocalPost extends UsersEvent {
  final Post post;

  const AddLocalPost(this.post);

  @override
  List<Object?> get props => [post];
}

// States
abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<User> users;
  final bool hasReachedMax;
  final String? searchQuery;
  final List<Post> localPosts;

  const UsersLoaded({
    required this.users,
    this.hasReachedMax = false,
    this.searchQuery,
    this.localPosts = const [],
  });

  @override
  List<Object?> get props => [users, hasReachedMax, searchQuery, localPosts];
}

class UserPostsLoading extends UsersState {}

class UserPostsLoaded extends UsersState {
  final List<Post> posts;
  final List<Post> localPosts;
  final int userId;

  const UserPostsLoaded({
    required this.posts,
    required this.userId,
    this.localPosts = const [],
  });

  @override
  List<Object?> get props => [posts, localPosts, userId];
}

class UserTodosLoading extends UsersState {}

class UserTodosLoaded extends UsersState {
  final List<Todo> todos;

  const UserTodosLoaded(this.todos);

  @override
  List<Object?> get props => [todos];
}

class UsersError extends UsersState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final GetUsers getUsers;
  final GetUserPosts getUserPosts;
  final GetUserTodos getUserTodos;
  final UserRepository userRepository;

  UsersBloc({
    required this.getUsers,
    required this.getUserPosts,
    required this.getUserTodos,
    required this.userRepository,
  }) : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<LoadUserPosts>(_onLoadUserPosts);
    on<LoadUserTodos>(_onLoadUserTodos);
    on<AddLocalPost>(_onAddLocalPost);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<UsersState> emit) async {
    try {
      if (event.skip == 0) {
        emit(UsersLoading());
      }

      final users = await getUsers(
        skip: event.skip,
        limit: event.limit,
        searchQuery: event.searchQuery,
      );

      if (users.isEmpty) {
        emit(
          UsersLoaded(
            users: event.skip == 0 ? [] : (state as UsersLoaded).users,
            hasReachedMax: true,
            searchQuery: event.searchQuery,
          ),
        );
      } else {
        emit(
          UsersLoaded(
            users:
                event.skip == 0
                    ? users
                    : [...(state as UsersLoaded).users, ...users],
            hasReachedMax: users.length < event.limit,
            searchQuery: event.searchQuery,
          ),
        );
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUserPosts(
    LoadUserPosts event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UserPostsLoading());
      final posts = await getUserPosts(event.userId);

      // Get local posts from current state if available
      List<Post> localPosts = [];
      if (state is UserPostsLoaded) {
        final currentState = state as UserPostsLoaded;
        if (currentState.userId == event.userId) {
          localPosts = currentState.localPosts;
        }
      } else if (state is UsersLoaded) {
        localPosts = (state as UsersLoaded).localPosts;
      }

      emit(
        UserPostsLoaded(
          posts: posts,
          userId: event.userId,
          localPosts: localPosts,
        ),
      );
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onLoadUserTodos(
    LoadUserTodos event,
    Emitter<UsersState> emit,
  ) async {
    try {
      emit(UserTodosLoading());
      final todos = await getUserTodos(event.userId);
      emit(UserTodosLoaded(todos));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onAddLocalPost(
    AddLocalPost event,
    Emitter<UsersState> emit,
  ) async {
    try {
      await userRepository.createLocalPost(event.post);
      if (state is UserPostsLoaded) {
        final currentState = state as UserPostsLoaded;
        final updatedPosts = List<Post>.from(currentState.posts)
          ..add(event.post);
        emit(UserPostsLoaded(posts: updatedPosts, userId: currentState.userId));
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}
