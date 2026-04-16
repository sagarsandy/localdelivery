import 'package:equatable/equatable.dart';

class StoreModel extends Equatable {
  const StoreModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTimeMinutes,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.isOpen,
    this.categories = const [],
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final int deliveryTimeMinutes;
  final double deliveryFee;
  final double minimumOrder;
  final bool isOpen;
  final List<String> categories;

  factory StoreModel.fromMap(Map<String, dynamic> map) => StoreModel(
        id: map['id'] as String,
        name: map['name'] as String,
        description: map['description'] as String? ?? '',
        imageUrl: map['image_url'] as String? ?? '',
        rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
        deliveryTimeMinutes: map['delivery_time_minutes'] as int? ?? 30,
        deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 0.0,
        minimumOrder: (map['minimum_order'] as num?)?.toDouble() ?? 0.0,
        isOpen: map['is_open'] as bool? ?? true,
        categories: List<String>.from(map['categories'] as List? ?? []),
      );

  @override
  List<Object?> get props => [id, name, rating, isOpen];
}
