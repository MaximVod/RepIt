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
  Future<void> removeCategory(CategoriesCompanion entry);

  /// Remove categories from db
  Future<void> removeCategories(Iterable<int> entries);

  /// Remove category from db
  Future<void> editCategory(CategoriesCompanion entry, String newCategoryName);
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
  Future<void> removeCategory(CategoriesCompanion entry) async {
    await delete(attachedDatabase.categories).delete(entry);
  }

  @override
  Future<void> editCategory(
    CategoriesCompanion entry,
    String newCategoryName,
  ) =>
      (update(attachedDatabase.categories)
            ..where((tbl) => tbl.title.like(entry.title.value)))
          .write(CategoriesCompanion(title: Value(newCategoryName)));

  @override
  Future<void> removeCategories(Iterable<int> entries) async {
    await (delete(attachedDatabase.categories)
          ..where((tbl) => tbl.id.isIn(entries)))
        .go();
  }
}
