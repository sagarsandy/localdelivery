import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/cart_item_model.dart';
import '../repositories/cart_repository.dart';

class UpdateCartUseCase {
  const UpdateCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Either<Failure, void>> updateCart(List<CartItemModel> items) =>
      _repository.updateCart(items);
}
