import '../../cart/models/cart_item.dart';

class Order {
  final List<CartItem> items;
  final DateTime orderedAt;

  Order({
    required this.items,
    required this.orderedAt,
  });

  int get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);
}
