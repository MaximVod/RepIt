import 'package:flutter/material.dart';

import 'package:repit/src/core/localization/localization.dart';

class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        Localization.of(context).favorites,
        style: Theme.of(context).textTheme.titleSmall,
      ),
      centerTitle: true,
    ),
  );
}
