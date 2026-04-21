import 'package:flutter_bloc/flutter_bloc.dart';

import '../../categories/domain/models/category_model.dart';
import '../../categories/domain/use_cases/get_categories_use_case.dart';
import '../../subcategories/domain/models/subcategory_model.dart';
import '../../subcategories/domain/use_cases/get_subcategories_use_case.dart';
import '../domain/models/product_model.dart';
import '../domain/use_cases/add_product_use_case.dart';
import '../domain/use_cases/delete_product_use_case.dart';
import '../domain/use_cases/get_products_use_case.dart';
import '../domain/use_cases/update_product_use_case.dart';
import 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(
    this._getCategories,
    this._getSubcategories,
    this._getProducts,
    this._addProduct,
    this._updateProduct,
    this._deleteProduct,
  ) : super(ProductsInitial());

  final GetCategoriesUseCase _getCategories;
  final GetSubcategoriesUseCase _getSubcategories;
  final GetProductsUseCase _getProducts;
  final AddProductUseCase _addProduct;
  final UpdateProductUseCase _updateProduct;
  final DeleteProductUseCase _deleteProduct;

  List<ProductModel> _allProducts = [];
  List<SubcategoryModel> _allSubcategories = [];
  List<CategoryModel> _categories = [];
  String? _selectedCategory;
  String? _selectedSubcategory;

  List<SubcategoryModel> get allSubcategories => _allSubcategories;

  List<SubcategoryModel> get _subcatsForSelected {
    if (_selectedCategory == null) return _allSubcategories;
    return _allSubcategories
        .where((s) => s.category == _selectedCategory)
        .toList();
  }

  List<ProductModel> get _filteredProducts {
    var list = _allProducts;
    if (_selectedCategory != null) {
      list = list.where((p) => p.category == _selectedCategory).toList();
    }
    if (_selectedSubcategory != null) {
      list = list.where((p) => p.subcategory == _selectedSubcategory).toList();
    }
    return list;
  }

  ProductsLoaded get _loadedState => ProductsLoaded(
        products: _filteredProducts,
        categories: _categories,
        subcategories: _subcatsForSelected,
        selectedCategory: _selectedCategory,
        selectedSubcategory: _selectedSubcategory,
      );

  Future<void> load() async {
    emit(ProductsLoading());

    final catsResult = await _getCategories.getCategories();
    final subcatsResult = await _getSubcategories.getSubcategories();
    final productsResult = await _getProducts.getProducts();

    final failure = catsResult.fold((f) => f, (_) => null) ??
        subcatsResult.fold((f) => f, (_) => null) ??
        productsResult.fold((f) => f, (_) => null);

    if (failure != null) {
      emit(ProductsError(failure.message));
      return;
    }

    _categories = catsResult.getOrElse(() => []);
    _allSubcategories = subcatsResult.getOrElse(() => []);
    _allProducts = productsResult.getOrElse(() => []);
    _selectedCategory = null;
    _selectedSubcategory = null;

    emit(_loadedState);
  }

  void filterByCategory(String? categoryTitle) {
    _selectedCategory = categoryTitle;
    final subcats = _subcatsForSelected;
    // Auto-select first subcategory in the newly filtered list.
    _selectedSubcategory =
        subcats.isNotEmpty ? subcats.first.title.toLowerCase() : null;
    if (state is ProductsLoaded ||
        state is ProductActionSuccess ||
        state is ProductActionError) {
      emit(_loadedState);
    }
  }

  void filterBySubcategory(String? subcategoryTitle) {
    _selectedSubcategory = subcategoryTitle;
    if (state is ProductsLoaded ||
        state is ProductActionSuccess ||
        state is ProductActionError) {
      emit(_loadedState);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    _emitInProgress();
    final result = await _addProduct.addProduct(product);
    result.fold(
      (failure) => emit(ProductActionError(
        products: _filteredProducts,
        categories: _categories,
        subcategories: _subcatsForSelected,
        selectedCategory: _selectedCategory,
        selectedSubcategory: _selectedSubcategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Product added successfully'),
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    _emitInProgress();
    final result = await _updateProduct.updateProduct(product);
    result.fold(
      (failure) => emit(ProductActionError(
        products: _filteredProducts,
        categories: _categories,
        subcategories: _subcatsForSelected,
        selectedCategory: _selectedCategory,
        selectedSubcategory: _selectedSubcategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Product updated successfully'),
    );
  }

  Future<void> deleteProduct({required String id}) async {
    _emitInProgress();
    final result = await _deleteProduct.deleteProduct(id: id);
    result.fold(
      (failure) => emit(ProductActionError(
        products: _filteredProducts,
        categories: _categories,
        subcategories: _subcatsForSelected,
        selectedCategory: _selectedCategory,
        selectedSubcategory: _selectedSubcategory,
        message: failure.message,
      )),
      (_) => _refreshAfterMutation('Product deleted successfully'),
    );
  }

  void _emitInProgress() {
    emit(ProductActionInProgress(
      products: _filteredProducts,
      categories: _categories,
      subcategories: _subcatsForSelected,
      selectedCategory: _selectedCategory,
      selectedSubcategory: _selectedSubcategory,
    ));
  }

  Future<void> _refreshAfterMutation(String successMessage) async {
    final result = await _getProducts.getProducts();
    result.fold(
      (_) {},
      (list) => _allProducts = list,
    );
    emit(ProductActionSuccess(
      products: _filteredProducts,
      categories: _categories,
      subcategories: _subcatsForSelected,
      selectedCategory: _selectedCategory,
      selectedSubcategory: _selectedSubcategory,
      message: successMessage,
    ));
  }
}
