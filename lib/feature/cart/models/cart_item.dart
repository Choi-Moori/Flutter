import '../../../core/constants/product_category.dart';


class CartItem {
  String name;
  int price;
  int quantity;
  ProductCategory category;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
  });

  int get totalPrice => price * quantity;

  CartItem copy() {
    return CartItem(
      name: name,
      price: price,
      quantity: quantity,
      category: category,
    );
  }
}
