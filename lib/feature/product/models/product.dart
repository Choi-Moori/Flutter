import '../../../core/constants/product_category.dart';

class Product {
  final String name;
  final int price;
  final ProductCategory category;

  Product({
    required this.name,
    required this.price,
    required this.category,
  });
}
