import 'dart:async';

import 'package:repit/src/core/utils/logger.dart';
import 'package:repit/src/feature/app/logic/app_runner.dart';

void main() {
  logger.runLogging(
    () => runZonedGuarded(
      () => const AppRunner().initializeAndRun(),
      logger.logZoneError,
    ),
    const LogOptions(),
  );
}
