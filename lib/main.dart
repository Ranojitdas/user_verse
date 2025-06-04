import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:userverse/core/di/injection_container.dart' as di;
import 'package:userverse/core/theme/app_theme.dart';
import 'package:userverse/core/theme/theme_bloc.dart';
import 'package:userverse/features/users/presentation/bloc/users_bloc.dart';
import 'package:userverse/features/users/presentation/pages/users_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.sl<UsersBloc>()),
        BlocProvider(create: (context) => di.sl<ThemeBloc>()..add(LoadTheme())),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'UserVerse',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const UsersPage(),
          );
        },
      ),
    );
  }
}
