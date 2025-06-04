import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:userverse/features/users/domain/entities/user.dart';
import 'package:userverse/features/users/presentation/pages/user_detail_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userverse/features/users/presentation/bloc/users_bloc.dart';

class UserListItem extends StatelessWidget {
  final User user;

  const UserListItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user.image),
        ),
        title: Text('${user.firstName} ${user.lastName}'),
        subtitle: Text(user.email),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider.value(
                    value: context.read<UsersBloc>(),
                    child: UserDetailPage(user: user),
                  ),
            ),
          );
        },
      ),
    );
  }
}
