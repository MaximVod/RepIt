// ignore_for_file: public_member_api_docs

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repit/src/feature/home/data/categories_repository.dart';
import 'package:repit/src/feature/home/model/category_entity.dart';

///States for logic with categories
sealed class CategoriesState {}

class CategoriesIdle implements CategoriesState {
  CategoriesIdle();
}

class CategoriesLoading implements CategoriesState {
  CategoriesLoading();
}

class CategoriesFetched implements CategoriesState {
  final List<CategoryEntity> categories;
  CategoriesFetched(this.categories);
}

class CategoriesFailure implements CategoriesState {
  final String error;
  CategoriesFailure(this.error);
}

///Events for logic with categories
sealed class CategoriesEvent {}

class FetchAllCategories implements CategoriesEvent {
  FetchAllCategories();
}

class AddCategory implements CategoriesEvent {
  final String categoryName;
  AddCategory(this.categoryName);
}

class RemoveCategory implements CategoriesEvent {
  final CategoryEntity entity;
  RemoveCategory(this.entity);
}

class EditCategory implements CategoriesEvent {
  final CategoryEntity entity;
  final String newCategoryName;
  EditCategory(this.entity, this.newCategoryName);
}

///Categories BLoC

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final CategoriesRepository _categoriesRepository;

  CategoriesBloc(CategoriesRepository categoriesRepository)
      : _categoriesRepository = categoriesRepository,
        super(CategoriesIdle()) {
    on<CategoriesEvent>(
      (event, emitter) => switch (event) {
        FetchAllCategories() => _fetchAllCategories(event, emitter),
        AddCategory() => _insertCategory(event, emitter, event.categoryName),
        RemoveCategory() => _removeCategory(event, emitter, event.entity),
        EditCategory() =>
          _editCategory(event, emitter, event.entity, event.newCategoryName)
      },
      transformer: bloc_concurrency.droppable(),
    );
  }

  Future<void> _fetchAllCategories(
    CategoriesEvent event,
    Emitter<CategoriesState> emitter,
  ) async {
    try {
      emitter(CategoriesLoading());
      final categories = await _categoriesRepository.getAllCategories();
      return emitter(CategoriesFetched(categories));
    } on Object catch (error) {
      emitter(
        CategoriesFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _insertCategory(
    CategoriesEvent event,
    Emitter<CategoriesState> emitter,
    String categoryName,
  ) async {
    try {
      emitter(CategoriesLoading());
      await _categoriesRepository.addCategory(categoryName);
      final categories = await _categoriesRepository.getAllCategories();
      return emitter(CategoriesFetched(categories));
    } on Object catch (error) {
      emitter(
        CategoriesFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _removeCategory(
    CategoriesEvent event,
    Emitter<CategoriesState> emitter,
    CategoryEntity entity,
  ) async {
    try {
      emitter(CategoriesLoading());
      await _categoriesRepository.removeCategory(entity);
      final categories = await _categoriesRepository.getAllCategories();
      return emitter(CategoriesFetched(categories));
    } on Object catch (error) {
      emitter(
        CategoriesFailure(error.toString()),
      );
      rethrow;
    }
  }

  Future<void> _editCategory(
      CategoriesEvent event,
      Emitter<CategoriesState> emitter,
      CategoryEntity entity,
      String newCategoryName,) async {
    try {
      emitter(CategoriesLoading());
      await _categoriesRepository.updateCategory(entity, newCategoryName);
      final categories = await _categoriesRepository.getAllCategories();
      return emitter(CategoriesFetched(categories));
    } on Object catch (error) {
      emitter(
        CategoriesFailure(error.toString()),
      );
      rethrow;
    }
  }
}
