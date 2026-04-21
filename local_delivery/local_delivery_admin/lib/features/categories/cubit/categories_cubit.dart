import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/models/category_model.dart';
import '../domain/use_cases/add_category_use_case.dart';
import '../domain/use_cases/delete_category_use_case.dart';
import '../domain/use_cases/get_categories_use_case.dart';
import '../domain/use_cases/update_category_use_case.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(
    this._getCategories,
    this._addCategory,
    this._updateCategory,
    this._deleteCategory,
  ) : super(CategoriesInitial());

  final GetCategoriesUseCase _getCategories;
  final AddCategoryUseCase _addCategory;
  final UpdateCategoryUseCase _updateCategory;
  final DeleteCategoryUseCase _deleteCategory;

  List<CategoryModel> _current = [];

  Future<void> loadCategories() async {
    emit(CategoriesLoading());
    final result = await _getCategories.getCategories();
    result.fold(
      (failure) => emit(CategoriesError(failure.message)),
      (list) {
        _current = list;
        emit(CategoriesLoaded(list));
      },
    );
  }

  Future<void> addCategory({
    required String title,
    required String image,
  }) async {
    emit(CategoryActionInProgress(_current));
    final result = await _addCategory.addCategory(title: title, image: image);
    result.fold(
      (failure) => emit(CategoryActionError(
        categories: _current,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Category added successfully'),
    );
  }

  Future<void> updateCategory({
    required String id,
    required String title,
    required String image,
  }) async {
    emit(CategoryActionInProgress(_current));
    final result = await _updateCategory.updateCategory(
      id: id,
      title: title,
      image: image,
    );
    result.fold(
      (failure) => emit(CategoryActionError(
        categories: _current,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Category updated successfully'),
    );
  }

  Future<void> deleteCategory({required String id}) async {
    emit(CategoryActionInProgress(_current));
    final result = await _deleteCategory.deleteCategory(id: id);
    result.fold(
      (failure) => emit(CategoryActionError(
        categories: _current,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Category deleted successfully'),
    );
  }

  Future<void> _refreshAfterMutation(String successMessage) async {
    final result = await _getCategories.getCategories();
    result.fold(
      (_) => emit(CategoryActionSuccess(
        categories: _current,
        message: successMessage,
      )),
      (list) {
        _current = list;
        emit(CategoryActionSuccess(
          categories: list,
          message: successMessage,
        ));
      },
    );
  }
}
