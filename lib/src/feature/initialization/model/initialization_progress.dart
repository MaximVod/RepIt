import 'package:repit/src/feature/initialization/model/dependencies.dart';
import 'package:repit/src/feature/initialization/model/environment_store.dart';

/// {@template initialization_progress}
/// A class which represents the initialization progress.
/// {@endtemplate}
final class InitializationProgress {
  /// {@macro initialization_progress}
  const InitializationProgress({
    required this.dependencies,
    required this.repositories,
    required this.environmentStore,
  });

  /// Mutable version of dependencies
  final Dependencies dependencies;

  /// Repositories container
  final Repositories repositories;

  /// Environment store
  final EnvironmentStore environmentStore;
}
