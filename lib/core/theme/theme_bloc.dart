import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}

// States
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({this.isDarkMode = false});

  @override
  List<Object?> get props => [isDarkMode];

  ThemeState copyWith({bool? isDarkMode}) {
    return ThemeState(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

// Bloc
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String THEME_KEY = 'is_dark_mode';

  ThemeBloc({required this.sharedPreferences}) : super(const ThemeState()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  void _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) {
    final isDarkMode = sharedPreferences.getBool(THEME_KEY) ?? false;
    emit(ThemeState(isDarkMode: isDarkMode));
  }

  void _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) {
    final newIsDarkMode = !state.isDarkMode;
    sharedPreferences.setBool(THEME_KEY, newIsDarkMode);
    emit(state.copyWith(isDarkMode: newIsDarkMode));
  }
}
