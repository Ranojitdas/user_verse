import 'package:flutter/material.dart';
import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreatePostScreen extends StatefulWidget {
  final Function(Post) onPostCreated;
  final int userId;

  const CreatePostScreen({
    super.key,
    required this.onPostCreated,
    required this.userId,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final newPost = Post(
          id: DateTime.now().millisecondsSinceEpoch,
          title: _titleController.text,
          body: _bodyController.text,
          userId: widget.userId,
        );
        widget.onPostCreated(newPost);
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body:
          _isLoading
              ? const Center(child: SpinKitCircle(color: Colors.blue))
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(labelText: 'Body'),
                        maxLines: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a body';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Save Post'),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
