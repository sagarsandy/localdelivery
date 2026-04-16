import 'package:dartz/dartz.dart';
import '../../../../core/utils/failure.dart';
import '../models/cart_item_model.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItemModel>>> getCart();
  Future<Either<Failure, void>> updateCart(List<CartItemModel> items);
  Future<Either<Failure, void>> clearCart();
}
