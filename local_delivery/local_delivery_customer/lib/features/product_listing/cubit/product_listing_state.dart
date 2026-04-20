import 'package:equatable/equatable.dart';
import '../domain/models/product_model.dart';

abstract class ProductListingState extends Equatable {
  const ProductListingState();

  @override
  List<Object?> get props => [];
}

class ProductListingInitial extends ProductListingState {
  const ProductListingInitial();
}

class ProductListingLoading extends ProductListingState {
  const ProductListingLoading();
}

class ProductListingLoaded extends ProductListingState {
  const ProductListingLoaded({required this.products});
  final List<ProductModel> products;

  @override
  List<Object?> get props => [products];
}

class ProductListingError extends ProductListingState {
  const ProductListingError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
