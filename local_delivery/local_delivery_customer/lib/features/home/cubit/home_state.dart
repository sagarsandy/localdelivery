import 'package:equatable/equatable.dart';
import '../domain/models/store_model.dart';
import '../domain/models/category_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.stores,
    required this.categories,
    this.selectedCategoryId,
  });
  final List<StoreModel> stores;
  final List<CategoryModel> categories;
  final String? selectedCategoryId;

  HomeLoaded copyWith({
    List<StoreModel>? stores,
    List<CategoryModel>? categories,
    String? selectedCategoryId,
  }) =>
      HomeLoaded(
        stores: stores ?? this.stores,
        categories: categories ?? this.categories,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      );

  @override
  List<Object?> get props => [stores, categories, selectedCategoryId];
}

class HomeError extends HomeState {
  const HomeError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
