import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/domain/models/category_model.dart';
import '../../categories/domain/use_cases/get_categories_use_case.dart';
import '../domain/models/subcategory_model.dart';
import '../domain/use_cases/add_subcategory_use_case.dart';
import '../domain/use_cases/delete_subcategory_use_case.dart';
import '../domain/use_cases/get_subcategories_use_case.dart';
import '../domain/use_cases/update_subcategory_use_case.dart';
import 'subcategories_state.dart';

class SubcategoriesCubit extends Cubit<SubcategoriesState> {
  SubcategoriesCubit(
    this._getCategories,
    this._getSubcategories,
    this._addSubcategory,
    this._updateSubcategory,
    this._deleteSubcategory,
  ) : super(SubcategoriesInitial());

  final GetCategoriesUseCase _getCategories;
  final GetSubcategoriesUseCase _getSubcategories;
  final AddSubcategoryUseCase _addSubcategory;
  final UpdateSubcategoryUseCase _updateSubcategory;
  final DeleteSubcategoryUseCase _deleteSubcategory;

  List<SubcategoryModel> _allSubcategories = [];
  List<CategoryModel> _categories = [];

  /// Lowercase category title used for filtering; null means show all.
  String? _selectedCategory;

  List<SubcategoryModel> get _filtered {
    if (_selectedCategory == null) return _allSubcategories;
    return _allSubcategories
        .where((s) => s.category == _selectedCategory)
        .toList();
  }

  Future<void> load() async {
    emit(SubcategoriesLoading());
    final categoriesResult = await _getCategories.getCategories();
    final subcatsResult = await _getSubcategories.getSubcategories();

    final categoriesFailure = categoriesResult.fold((f) => f, (_) => null);
    final subcatsFailure = subcatsResult.fold((f) => f, (_) => null);

    if (categoriesFailure != null) {
      emit(SubcategoriesError(categoriesFailure.message));
      return;
    }
    if (subcatsFailure != null) {
      emit(SubcategoriesError(subcatsFailure.message));
      return;
    }

    _categories = categoriesResult.getOrElse(() => []);
    _allSubcategories = subcatsResult.getOrElse(() => []);
    _selectedCategory = null;

    emit(SubcategoriesLoaded(
      subcategories: _filtered,
      categories: _categories,
    ));
  }

  void filterByCategory(String? categoryTitle) {
    _selectedCategory = categoryTitle;
    final current = state;
    if (current is SubcategoriesLoaded) {
      emit(SubcategoriesLoaded(
        subcategories: _filtered,
        categories: _categories,
        selectedCategory: _selectedCategory,
      ));
    }
  }

  Future<void> addSubcategory({
    required String title,
    required String image,
    required String category,
  }) async {
    emit(SubcategoryActionInProgress(
      subcategories: _filtered,
      categories: _categories,
      selectedCategory: _selectedCategory,
    ));
    final result = await _addSubcategory.addSubcategory(
        title: title, image: image, category: category);
    result.fold(
      (failure) => emit(SubcategoryActionError(
        subcategories: _filtered,
        categories: _categories,
        selectedCategory: _selectedCategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Subcategory added successfully'),
    );
  }

  Future<void> updateSubcategory({
    required String id,
    required String title,
    required String image,
    required String category,
  }) async {
    emit(SubcategoryActionInProgress(
      subcategories: _filtered,
      categories: _categories,
      selectedCategory: _selectedCategory,
    ));
    final result = await _updateSubcategory.updateSubcategory(
        id: id, title: title, image: image, category: category);
    result.fold(
      (failure) => emit(SubcategoryActionError(
        subcategories: _filtered,
        categories: _categories,
        selectedCategory: _selectedCategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Subcategory updated successfully'),
    );
  }

  Future<void> deleteSubcategory({required String id}) async {
    emit(SubcategoryActionInProgress(
      subcategories: _filtered,
      categories: _categories,
      selectedCategory: _selectedCategory,
    ));
    final result = await _deleteSubcategory.deleteSubcategory(id: id);
    result.fold(
      (failure) => emit(SubcategoryActionError(
        subcategories: _filtered,
        categories: _categories,
        selectedCategory: _selectedCategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Subcategory deleted successfully'),
    );
  }

  Future<void> _refreshAfterMutation(String successMessage) async {
    final result = await _getSubcategories.getSubcategories();
    result.fold(
      (_) => emit(SubcategoryActionSuccess(
        subcategories: _filtered,
        categories: _categories,
        selectedCategory: _selectedCategory,
        message: successMessage,
      )),
      (list) {
        _allSubcategories = list;
        emit(SubcategoryActionSuccess(
          subcategories: _filtered,
          categories: _categories,
          selectedCategory: _selectedCategory,
          message: successMessage,
        ));
      },
    );
  }
}
