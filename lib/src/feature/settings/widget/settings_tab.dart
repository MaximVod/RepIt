import 'package:flutter/material.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/settings/widget/settings_scope.dart';

/// List of available languages
const List<String> languageList = <String>['English', 'Русский'];

///Tab for settings
class SettingsTab extends StatelessWidget {
  /// Icons states for theme switcher
  final MaterialStateProperty<Icon?> themeIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.dark_mode);
      }
      return const Icon(Icons.light_mode);
    },
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
            Localization.of(context).settings,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Localization.of(context).app_theme,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              Switch(
                thumbIcon: themeIcon,
                value: SettingsScope.of(context).theme.mode == ThemeMode.dark,
                onChanged: (bool value) {
                  value
                      ? SettingsScope.of(context).setThemeMode(ThemeMode.dark)
                      : SettingsScope.of(context).setThemeMode(ThemeMode.light);
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                Localization.of(context).language,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              DropdownMenu<String>(
                initialSelection:
                    SettingsScope.of(context).locale.languageCode == "en"
                        ? languageList.first
                        : languageList.last,
                onSelected: (String? value) {
                  value == languageList.first
                      ? SettingsScope.of(context).setLocale(const Locale("en"))
                      : SettingsScope.of(context).setLocale(const Locale("ru"));
                },
                dropdownMenuEntries: languageList
                    .map<DropdownMenuEntry<String>>(
                      (String value) =>
                          DropdownMenuEntry<String>(value: value, label: value),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      );
}
