import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/components/database/src/tables/cards.dart';
import 'package:repit/src/core/components/database/src/tables/category.dart';

part 'app_database.g.dart';

/// {@template app_database}
/// The drift-managed database configuration
/// {@endtemplate}
@DriftDatabase(tables: [Categories, Cards])
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? createExecutor());

  @override
  int get schemaVersion => 1;
}
