import '../dto/store_dto.dart';

abstract class StoreRemoteSource {
  /// Fetches active stores, optionally filtered by [categoryId].
  Future<List<StoreDto>> fetchStores({String? categoryId});
}
