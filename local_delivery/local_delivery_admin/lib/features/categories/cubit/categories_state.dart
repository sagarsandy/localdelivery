import 'package:equatable/equatable.dart';
import '../domain/models/category_model.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded(this.categories);
  final List<CategoryModel> categories;
  @override
  List<Object?> get props => [categories];
}

class CategoriesError extends CategoriesState {
  const CategoriesError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

/// Emitted while an add / edit / delete operation is in flight.
/// Carries the current list so the UI stays populated.
class CategoryActionInProgress extends CategoriesState {
  const CategoryActionInProgress(this.categories);
  final List<CategoryModel> categories;
  @override
  List<Object?> get props => [categories];
}

/// Emitted after a successful mutation. Carries the refreshed list.
class CategoryActionSuccess extends CategoriesState {
  const CategoryActionSuccess({
    required this.categories,
    required this.message,
  });
  final List<CategoryModel> categories;
  final String message;
  @override
  List<Object?> get props => [categories, message];
}

/// Emitted when a mutation fails. Carries the unchanged list.
class CategoryActionError extends CategoriesState {
  const CategoryActionError({
    required this.categories,
    required this.message,
  });
  final List<CategoryModel> categories;
  final String message;
  @override
  List<Object?> get props => [categories, message];
}
