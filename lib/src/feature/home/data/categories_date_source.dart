import 'package:drift/drift.dart';
import 'package:repit/src/core/components/database/database.dart';
import 'package:repit/src/core/components/database/src/tables/category.dart';

part 'categories_date_source.g.dart';

/// Repository interface for cards categories date source
abstract interface class CategoriesDataSource {
  /// Get all categories
  Future<List<Category>> getAllCategories();

  /// Add category to db
  Future<void> addCategory(CategoriesCompanion categoriesCompanion);

  /// Remove category from db
  Future<void> removeCategory(int id);

  /// Remove categories from db
  Future<void> removeCategories(Iterable<int> entries);

  /// Remove category from db
  Future<void> editCategory(int id, String newCategoryName);
}

/// DAO categories
@DriftAccessor(tables: [Categories])
class CategoriesDao extends DatabaseAccessor<AppDatabase>
    with _$CategoriesDaoMixin
    implements CategoriesDataSource {
  // ignore: public_member_api_docs
  CategoriesDao(super.attachedDatabase);

  @override
  Future<void> addCategory(CategoriesCompanion categoriesCompanion) =>
      into(attachedDatabase.categories).insert(categoriesCompanion);

  @override
  Future<List<Category>> getAllCategories() =>
      select(attachedDatabase.categories).get();

  @override
  Future<void> removeCategory(int id) async {
    await (delete(attachedDatabase.categories)
      ..where((tbl) => tbl.id.isValue(id)))
        .go();
  }

  @override
  Future<void> editCategory(
    int id,
    String newCategoryName,
  ) =>
      (update(attachedDatabase.categories)
            ..where((tbl) => tbl.id.isValue(id)))
          .write(CategoriesCompanion(title: Value(newCategoryName)));

  @override
  Future<void> removeCategories(Iterable<int> entries) async {
    await (delete(attachedDatabase.categories)
          ..where((tbl) => tbl.id.isIn(entries)))
        .go();
  }
}
