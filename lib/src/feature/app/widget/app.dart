import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/app/widget/material_context.dart';
import 'package:repit/src/feature/categories/bloc/categories_bloc.dart';
import 'package:repit/src/feature/initialization/logic/initialization_processor.dart';
import 'package:repit/src/feature/initialization/model/dependencies.dart';
import 'package:repit/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:repit/src/feature/settings/widget/settings_scope.dart';

/// {@template app}
/// [App] is an entry point to the application.
///
/// Scopes that don't depend on widgets returned by [MaterialApp]
/// ([Directionality], [MediaQuery], [Localizations]) should be placed here.
/// {@endtemplate}
class App extends StatelessWidget {
  /// {@macro app}
  const App({required this.result, super.key});

  /// The initialization result from the [InitializationProcessor]
  /// which contains initialized dependencies.
  final InitializationResult result;

  @override
  Widget build(BuildContext context) => DependenciesScope(
        dependencies: result.dependencies,
        repositories: result.repositories,
        child: SettingsScope(
          settingsBloc: result.dependencies.settingsBloc,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    CategoriesBloc(result.repositories.categoriesRepository)
                      ..add(
                        FetchAllCategories(),
                      ),
              ),
            ],
            child: const MaterialContext(),
          ),
        ),
      );
}
