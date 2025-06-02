import '../models/product.dart';
import '../../cart/models/cart_item.dart';
import '../../../core/constants/product_category.dart';


class ShoppingController {
  final List<Product> products;
  final List<CartItem> cart;

  ShoppingController({
    required this.products,
    required this.cart,
  });

  List<Product> filterProducts(String query, ProductCategory? selectedCategory) {
    return products.where((p) {
      final nameMatch = p.name.toLowerCase().contains(query.toLowerCase());
      final categoryMatch = categoryToKorean(p.category).contains(query);
      final searchMatch = query.isEmpty || nameMatch || categoryMatch;
      final categoryFilterMatch = selectedCategory == null || p.category == selectedCategory;
      return searchMatch && categoryFilterMatch;
    }).toList();
  }

  void addToCart(Product product) {
    final index = cart.indexWhere((item) => item.name == product.name);
    if (index != -1) {
      cart[index].quantity++;
    } else {
      cart.add(CartItem(
        name: product.name,
        price: product.price,
        category: product.category,
        quantity: 1,
      ));
    }
  }

  String categoryToKorean(ProductCategory category) {
    switch (category) {
      case ProductCategory.outer: return '아우터';
      case ProductCategory.top: return '상의';
      case ProductCategory.bottom: return '하의';
      case ProductCategory.shoes: return '신발';
    }
  }
}
