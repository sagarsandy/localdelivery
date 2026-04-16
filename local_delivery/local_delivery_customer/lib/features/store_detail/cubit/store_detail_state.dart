import 'package:equatable/equatable.dart';

import '../../home/domain/models/store_model.dart';
import '../domain/models/product_model.dart';

abstract class StoreDetailState extends Equatable {
  const StoreDetailState();
  @override
  List<Object?> get props => [];
}

class StoreDetailInitial extends StoreDetailState {}

class StoreDetailLoading extends StoreDetailState {}

class StoreDetailLoaded extends StoreDetailState {
  const StoreDetailLoaded({
    required this.store,
    required this.products,
    this.selectedCategoryId,
  });

  final StoreModel store;
  final List<ProductModel> products;
  final String? selectedCategoryId;

  StoreDetailLoaded copyWith({
    StoreModel? store,
    List<ProductModel>? products,
    String? selectedCategoryId,
  }) =>
      StoreDetailLoaded(
        store: store ?? this.store,
        products: products ?? this.products,
        selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      );

  @override
  List<Object?> get props => [store, products, selectedCategoryId];
}

class StoreDetailError extends StoreDetailState {
  const StoreDetailError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}
