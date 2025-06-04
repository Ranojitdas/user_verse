import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userverse/core/di/injection_container.dart';
import 'package:userverse/features/users/domain/entities/post.dart';
import 'package:userverse/features/users/domain/entities/todo.dart';
import 'package:userverse/features/users/domain/entities/user.dart';
import 'package:userverse/features/users/presentation/bloc/users_bloc.dart';
import 'package:userverse/features/users/presentation/widgets/post_list_item.dart';
import 'package:userverse/features/users/presentation/widgets/todo_list_item.dart';
import 'package:userverse/features/users/presentation/pages/create_post_screen.dart';

class UserDetailPage extends StatefulWidget {
  final User user;

  const UserDetailPage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late UsersBloc _usersBloc;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupAnimation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _usersBloc = context.read<UsersBloc>();
    _loadUserData();
  }

  void _setupAnimation() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    _usersBloc.add(LoadUserPosts(widget.user.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _usersBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${widget.user.firstName} ${widget.user.lastName}'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Posts'),
              Tab(text: 'Todos'),
            ],
          ),
        ),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsersError) {
              return Center(child: Text(state.message));
            } else if (state is UserPostsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildUserInfo(),
                  _buildPostsTabView(state.posts),
                  _buildTodosTab([]),
                ],
              );
            } else if (state is UserTodosLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildUserInfo(),
                  _buildPostsTabView([]),
                  _buildTodosTab(state.todos),
                ],
              );
            } else {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildUserInfo(),
                  const Center(child: Text('No posts available')),
                  const Center(child: Text('No todos available')),
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => CreatePostScreen(
                      userId: widget.user.id,
                      onPostCreated: (Post post) {
                        _usersBloc.add(AddLocalPost(post));
                      },
                    ),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SingleChildScrollView(
        child: Column(children: [_buildProfileHeader(), _buildInfoSection()]),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Row(
        children: [
          Hero(
            tag: 'user_${widget.user.id}',
            child: CircleAvatar(
              radius: 40,
              backgroundImage: CachedNetworkImageProvider(widget.user.image),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.email,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.user.username,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoGroup('Personal Information', [
            _buildInfoRow(
              Icons.person_outline,
              'Username',
              widget.user.username,
            ),
            _buildInfoRow(
              Icons.cake_outlined,
              'Age',
              '${widget.user.age} years',
            ),
            _buildInfoRow(Icons.wc_outlined, 'Gender', widget.user.gender),
            _buildInfoRow(
              Icons.calendar_today_outlined,
              'Birth Date',
              widget.user.birthDate,
            ),
          ]),
          const SizedBox(height: 16),
          _buildInfoGroup('Contact Information', [
            _buildInfoRow(Icons.phone_outlined, 'Phone', widget.user.phone),
          ]),
          const SizedBox(height: 16),
          _buildInfoGroup('Physical Information', [
            _buildInfoRow(
              Icons.bloodtype_outlined,
              'Blood Group',
              widget.user.bloodGroup,
            ),
            _buildInfoRow(
              Icons.height_outlined,
              'Height',
              '${widget.user.height} cm',
            ),
            _buildInfoRow(
              Icons.monitor_weight_outlined,
              'Weight',
              '${widget.user.weight} kg',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTabView(List<Post> posts) {
    if (posts.isEmpty) {
      return const Center(child: Text('No posts found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadUserData();
      },
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return PostListItem(post: posts[index]);
        },
      ),
    );
  }

  Widget _buildTodosTab(List<Todo> todos) {
    if (todos.isEmpty) {
      return const Center(child: Text('No todos found'));
    }

    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoListItem(todo: todos[index]);
      },
    );
  }
}
