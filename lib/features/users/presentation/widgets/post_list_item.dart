import 'package:flutter/material.dart';
import 'package:userverse/features/users/domain/entities/post.dart';

class PostListItem extends StatelessWidget {
  final Post post;

  const PostListItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(post.body, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
