part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {
  final AppThemeData theme = AppThemes.softDark;
}

final class ThemeInitial extends ThemeState {}

final class CurrentTheme extends ThemeState {
  @override
  final AppThemeData theme;

  CurrentTheme(this.theme);
}
