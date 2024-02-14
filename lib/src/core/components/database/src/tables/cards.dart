// ignore_for_file: prefer-declaring-const-constructor
import 'package:drift/drift.dart';

/// Table for cards
class Cards extends Table {
  /// The identifier for this card.
  IntColumn get id => integer().autoIncrement()();

  /// The category identifier for this card.
  IntColumn get categoryId => integer()();

  /// The name of card.
  TextColumn get cardName => text().withLength(min: 2, max: 21)();

  /// The value of card.
  TextColumn get cardValue => text().withLength(min: 2, max: 50)();

  /// Is card favorite.
  BoolColumn get isFavorite =>
      boolean().withDefault(Variable<bool>(true))();
}
