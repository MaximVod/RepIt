// ignore_for_file: prefer-declaring-const-constructor
import 'package:drift/drift.dart';

/// Todos table definition
class Categories extends Table {
  /// The identifier for this category.
  IntColumn get id => integer().autoIncrement()();

  /// The title of this category.
  TextColumn get title => text().withLength(min: 6, max: 32)();
}
