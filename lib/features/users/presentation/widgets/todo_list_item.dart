import 'package:flutter/material.dart';
import 'package:userverse/features/users/domain/entities/todo.dart';

class TodoListItem extends StatelessWidget {
  final Todo todo;
  const TodoListItem({Key? key, required this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      trailing: Icon(
        todo.completed ? Icons.check_circle : Icons.radio_button_unchecked,
        color: todo.completed ? Colors.green : Colors.grey,
      ),
    );
  }
}
