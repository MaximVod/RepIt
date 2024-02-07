import 'package:repit/src/feature/cards/data/cards_repository.dart';
import 'package:repit/src/feature/home/data/categories_repository.dart';
import 'package:repit/src/feature/settings/bloc/settings_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template dependencies}
/// Dependencies container
/// {@endtemplate}
base class Dependencies {
  /// {@macro dependencies}
  const Dependencies({
    required this.sharedPreferences,
    required this.settingsBloc,
  });

  /// [SharedPreferences] instance, used to store Key-Value pairs.
  final SharedPreferences sharedPreferences;

  /// [SettingsBloc] instance, used to manage theme and locale.
  final SettingsBloc settingsBloc;
}

/// {@template dependencies}
/// Repositories container
/// {@endtemplate}
base class Repositories {
  /// {@macro dependencies}
  const Repositories({
    required this.categoriesRepository,
    required this.cardsRepository,
  });

  /// [CategoriesRepository] instance
  final CategoriesRepository categoriesRepository;
  /// [CardsRepository] instance
  final CardsRepository cardsRepository;

}

/// {@template initialization_result}
/// Result of initialization
/// {@endtemplate}
final class InitializationResult {
  /// {@macro initialization_result}
  const InitializationResult({
    required this.dependencies,
    required this.repositories,
    required this.msSpent,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The dependencies
  final Repositories repositories;

  /// The number of milliseconds spent
  final int msSpent;

  @override
  String toString() => '$InitializationResult('
      'dependencies: $dependencies, '
      'msSpent: $msSpent'
      ')';
}
