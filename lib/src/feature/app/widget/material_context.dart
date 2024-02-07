import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';
import 'package:repit/src/common/router/router_state_mixin.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/core/theme/color_scheme.dart';
import 'package:repit/src/feature/settings/widget/settings_scope.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class MaterialContext extends StatefulWidget {
  /// {@macro material_context}
  const MaterialContext({super.key});

  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final _globalKey = GlobalKey();

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState extends State<MaterialContext>
    with RouterStateMixin {
  @override
  Widget build(BuildContext context) {
    final theme = SettingsScope.themeOf(context).theme;
    final locale = SettingsScope.localeOf(context).locale;

    return MaterialApp.router(
      key: MaterialContext._globalKey,
      theme: lightThemeData,
      darkTheme: darkThemeData,
      themeMode: theme.mode,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      locale: locale,
      routerConfig: router.config,
      builder: (context, child) => MediaQuery.withClampedTextScaling(
        minScaleFactor: 1.0,
        maxScaleFactor: 2.0,
        child: OctopusTools(octopus: router, child: child ?? const SizedBox()),
      ),
    );
  }
}
