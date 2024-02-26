import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/utils/logger.dart';
import 'package:repit/src/feature/cards/data/cards_data_source.dart';
import 'package:repit/src/feature/cards/data/cards_repository.dart';
import 'package:repit/src/feature/categories/data/categories_date_source.dart';
import 'package:repit/src/feature/categories/data/categories_repository.dart';
import 'package:repit/src/feature/initialization/model/dependencies.dart';
import 'package:repit/src/feature/initialization/model/environment_store.dart';
import 'package:repit/src/feature/settings/bloc/settings_bloc.dart';
import 'package:repit/src/feature/settings/data/locale_datasource.dart';
import 'package:repit/src/feature/settings/data/locale_repository.dart';
import 'package:repit/src/feature/settings/data/theme_datasource.dart';
import 'package:repit/src/feature/settings/data/theme_mode_codec.dart';
import 'package:repit/src/feature/settings/data/theme_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'initialization_factory.dart';

/// {@template initialization_processor}
/// A class which is responsible for processing initialization steps.
/// {@endtemplate}
final class InitializationProcessor {
  //final ExceptionTrackingManager _trackingManager;
  final EnvironmentStore _environmentStore;

  /// {@macro initialization_processor}
  const InitializationProcessor({
    //required ExceptionTrackingManager trackingManager,
    required EnvironmentStore environmentStore,
  }) : //_trackingManager = trackingManager,
        _environmentStore = environmentStore;

  Future<Dependencies> _initDependencies() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    final settingsBloc = await _initSettingsBloc(sharedPreferences);

    return Dependencies(
      sharedPreferences: sharedPreferences,
      settingsBloc: settingsBloc,
    );
  }

  Future<Repositories> _initRepositories() async {
    final appDatebase = AppDatabase();
    final categoriesRepository =
        CategoriesRepositoryImpl(CategoriesDao(appDatebase));
    final cardsRepository = CardsRepositoryImpl(CardsDao(appDatebase));

    return Repositories(
      categoriesRepository: categoriesRepository,
      cardsRepository: cardsRepository,
    );
  }

  Future<SettingsBloc> _initSettingsBloc(SharedPreferences prefs) async {
    final localeRepository = LocaleRepositoryImpl(
      localeDataSource: LocaleDataSourceLocal(sharedPreferences: prefs),
    );

    final themeRepository = ThemeRepositoryImpl(
      themeDataSource: ThemeDataSourceLocal(
        sharedPreferences: prefs,
        codec: const ThemeModeCodec(),
      ),
    );

    final localeFuture = localeRepository.getLocale();
    final theme = await themeRepository.getTheme();
    final locale = await localeFuture;

    final initialState = SettingsState.idle(appTheme: theme, locale: locale);

    final settingsBloc = SettingsBloc(
      localeRepository: localeRepository,
      themeRepository: themeRepository,
      initialState: initialState,
    );
    return settingsBloc;
  }

  /// Method that starts the initialization process
  /// and returns the result of the initialization.
  ///
  /// This method may contain additional steps that need initialization
  /// before the application starts
  /// (for example, caching or enabling tracking manager)
  Future<InitializationResult> initialize() async {
    if (_environmentStore.enableTrackingManager) {
      // await _trackingManager.enableReporting();
    }
    final stopwatch = Stopwatch()..start();

    logger.info('Initializing dependencies...');
    // initialize dependencies
    final dependencies = await _initDependencies();
    logger.info('Dependencies initialized');
    // initialize dependencies
    final repositories = await _initRepositories();
    logger.info('Repositories initialized');

    stopwatch.stop();
    final result = InitializationResult(
      dependencies: dependencies,
      repositories: repositories,
      msSpent: stopwatch.elapsedMilliseconds,
    );
    return result;
  }
}
