import 'package:equatable/equatable.dart';

class TrendingProductModel extends Equatable {
  const TrendingProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;

  @override
  List<Object?> get props => [id, name, price];
}
