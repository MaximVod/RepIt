import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';
import 'package:repit/src/common/router/routes.dart';

/// Mixin for router instance and observe navigation
mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  /// Router instance
  late final Octopus router;

  /// Router observer
  late final ValueNotifier<List<({Object error, StackTrace stackTrace})>>
      errorsObserver;

  @override
  void initState() {
    // Observe all errors.
    errorsObserver =
        ValueNotifier<List<({Object error, StackTrace stackTrace})>>(
      <({Object error, StackTrace stackTrace})>[],
    );

    // Create router.
    router = Octopus(
      routes: Routes.values,
      defaultRoute: Routes.home,
      transitionDelegate: const DefaultTransitionDelegate<void>(),
      onError: (error, stackTrace) =>
          errorsObserver.value = <({Object error, StackTrace stackTrace})>[
        (error: error, stackTrace: stackTrace),
        ...errorsObserver.value,
      ],
      /* observers: <NavigatorObserver>[
        HeroController(),
      ], */
    );
    super.initState();
  }
}
