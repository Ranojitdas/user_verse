import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userverse/core/di/injection_container.dart';
import 'package:userverse/core/theme/theme_bloc.dart';
import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/presentation/bloc/users_bloc.dart';
import 'package:userverse/features/users/presentation/widgets/user_list_item.dart';
import 'package:userverse/features/users/presentation/widgets/user_search_bar.dart';
import 'package:userverse/features/users/presentation/pages/create_post_screen.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<UsersBloc>()..add(const LoadUsers()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('UserVerse'),
          actions: [
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return IconButton(
                  icon: Icon(
                    state.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  onPressed: () {
                    context.read<ThemeBloc>().add(ToggleTheme());
                  },
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const UserSearchBar(),
            Expanded(
              child: BlocBuilder<UsersBloc, UsersState>(
                builder: (context, state) {
                  if (state is UsersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UsersLoaded) {
                    if (state.users.isEmpty) {
                      return const Center(child: Text('No users found'));
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<UsersBloc>().add(const LoadUsers(skip: 0));
                      },
                      child: ListView.builder(
                        itemCount:
                            state.users.length + (state.hasReachedMax ? 0 : 1),
                        itemBuilder: (context, index) {
                          if (index >= state.users.length) {
                            context.read<UsersBloc>().add(
                              LoadUsers(
                                skip: state.users.length,
                                searchQuery: state.searchQuery,
                              ),
                            );
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return UserListItem(user: state.users[index]);
                        },
                      ),
                    );
                  } else if (state is UsersError) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
