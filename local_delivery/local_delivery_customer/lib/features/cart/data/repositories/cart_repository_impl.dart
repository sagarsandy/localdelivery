import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/failure.dart';
import '../../domain/models/cart_item_model.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  static const _cartKey = 'ld_cart_items';

  @override
  Future<Either<Failure, List<CartItemModel>>> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cartKey);
      if (jsonString == null) return const Right([]);
      final jsonList = jsonDecode(jsonString) as List<dynamic>;
      final items =
          jsonList.map((e) => CartItemModel.fromMap(e as Map<String, dynamic>)).toList();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateCart(List<CartItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(items.map((e) => e.toMap()).toList());
      await prefs.setString(_cartKey, jsonString);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
