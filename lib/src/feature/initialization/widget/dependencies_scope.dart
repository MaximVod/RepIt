import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:repit/src/core/utils/extensions/context_extension.dart';
import 'package:repit/src/feature/initialization/model/dependencies.dart';

/// {@template dependencies_scope}
/// A widget which is responsible for providing the dependencies.
/// {@endtemplate}
class DependenciesScope extends InheritedWidget {
  /// {@macro dependencies_scope}
  const DependenciesScope({
    required super.child,
    required this.dependencies,
    required this.repositories,
    super.key,
  });

  /// The dependencies
  final Dependencies dependencies;

  /// The dependencies
  final Repositories repositories;

  /// Get the dependencies from the [context].
  static Dependencies dependenciesOf(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).dependencies;

  /// Get only the repositories from the [context].
  static Repositories repositoriesOf(BuildContext context) =>
      context.inhOf<DependenciesScope>(listen: false).repositories;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Dependencies>('dependencies', dependencies),
    );
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => false;
}
