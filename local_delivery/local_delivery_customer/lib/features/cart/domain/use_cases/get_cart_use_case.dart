import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/cart_item_model.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  const GetCartUseCase(this._repository);
  final CartRepository _repository;

  Future<Either<Failure, List<CartItemModel>>> getCart() =>
      _repository.getCart();
}
