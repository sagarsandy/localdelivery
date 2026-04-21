import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/product_model.dart';

class ProductDto {
  const ProductDto({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.subcategory,
    required this.price,
    required this.originalPrice,
    required this.quantity,
    required this.units,
    required this.inStock,
    required this.isAvailable,
  });

  final String id;
  final String title;
  final String description;
  final String image;
  final String category;
  final String subcategory;
  final double price;
  final double originalPrice;
  final int quantity;
  final String units;
  final bool inStock;
  final bool isAvailable;

  factory ProductDto.fromFirestore(QueryDocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ProductDto(
      id: doc.id,
      title: d['title'] as String? ?? '',
      description: d['description'] as String? ?? '',
      image: d['image'] as String? ?? '',
      category: d['category'] as String? ?? '',
      subcategory: d['subcategory'] as String? ?? '',
      price: (d['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (d['originalPrice'] as num?)?.toDouble() ?? 0.0,
      quantity: (d['quantity'] as num?)?.toInt() ?? 0,
      units: d['units'] as String? ?? '',
      inStock: d['inStock'] as bool? ?? true,
      isAvailable: d['isAvailable'] as bool? ?? true,
    );
  }

  ProductModel toDomain() => ProductModel(
        id: id,
        title: title,
        description: description,
        image: image,
        category: category,
        subcategory: subcategory,
        price: price,
        originalPrice: originalPrice,
        quantity: quantity,
        units: units,
        inStock: inStock,
        isAvailable: isAvailable,
      );

  static Map<String, dynamic> fromModel(ProductModel m) => {
        'title': m.title.trim(),
        'description': m.description.trim(),
        'image': m.image.trim(),
        'category': m.category.toLowerCase(),
        'subcategory': m.subcategory.toLowerCase(),
        'price': m.price,
        'originalPrice': m.originalPrice,
        'quantity': m.quantity,
        'units': m.units.trim(),
        'inStock': m.inStock,
        'isAvailable': m.isAvailable,
      };
}
