import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/core/localization/localization.dart';
import 'package:repit/src/feature/categories/bloc/categories_bloc.dart';
import 'package:repit/src/feature/categories/widget/categories_screen.dart';
import 'package:repit/src/feature/favorites/bloc/favorites_bloc.dart';
import 'package:repit/src/feature/favorites/widget/favorites_tab.dart';
import 'package:repit/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:repit/src/feature/settings/widget/settings_tab.dart';

/// AppTabs enumeration
enum AppTabs {
  /// Categories tab [CategoriesTab]
  categories,

  /// Favorites tab [FavoritesTab]
  favorites,

  /// Settings tab [SettingsTab]
  settings
}

///HomeScreen with bottom navigation
class HomeScreen extends StatefulWidget {
  ///Home Screen constructor
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Current tab
  AppTabs _tab = AppTabs.categories;

  // Bottom navigation bar item tapped
  void _onItemTapped(BuildContext context, int index) {
    final newTab = AppTabs.values[index];
    if (newTab == AppTabs.favorites) {
      context.read<FavoritesCardsBloc>().add(FetchFavCards());
    }
    _switchTab(newTab);
  }

  // Change tab
  void _switchTab(AppTabs tab) {
    if (!mounted) return;
    if (_tab == tab) return;
    setState(() => _tab = tab);
  }

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => CategoriesBloc(
              DependenciesScope.repositoriesOf(context).categoriesRepository,
            )..add(
                FetchAllCategories(),
              ),
          ),
          BlocProvider(
            create: (context) => FavoritesCardsBloc(
              DependenciesScope.repositoriesOf(context).favoritesRepository,
            ),
          ),
        ],
        child: Scaffold(
          body: IndexedStack(
            index: _tab.index,
            children: [
              const CategoriesTab(),
              const FavoritesTab(),
              SettingsTab(),
            ],
          ),
          bottomNavigationBar: Builder(
            builder: (buildContext) => BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.category),
                  label: Localization.of(context).categories,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite),
                  label: Localization.of(context).favorites,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: Localization.of(context).settings,
                ),
              ],
              currentIndex: _tab.index,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              onTap: (index) => _onItemTapped(buildContext, index),
            ),
          ),
        ),
      );
}
